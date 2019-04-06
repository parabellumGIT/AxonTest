//
//  NewNetworkManager.swift
//  Mawi
//
//  Created by ParaBellum on 5/20/18.
//  Copyright © 2018 yuravake. All rights reserved.
//

import Foundation
import SystemConfiguration

public enum Result<Value> {
    case success(Value)
    case failure(Error)
    
    init(success x: Value) {
        self = .success(x)
    }
    
    init(failure: Error) {
        self = .failure(failure)
    }
}

class NM {
    
    static let shared = NM()
    private let reachabilityManager = NetworkReachabilityManager.shared
    
    private init() {
        NetworkReachabilityManager.isReachable { _ in
            self.hasConnection = true
        }
        
        NetworkReachabilityManager.isUnreachable { _ in
            self.hasConnection = false
        }
        reachabilityManager.reachability.whenReachable = { _ in
            self.hasConnection = true
        }
        reachabilityManager.reachability.whenUnreachable = { _ in
            self.hasConnection = false
        }
    }
    
    private var hasConnection: Bool = false
    
    private let router = Router<RandomUserEndPoint>()
    
    func cancel() {
        router.cancel()
    }
    
    fileprivate func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<String> {
        NetworkLogger.log(response: response)
        switch response.statusCode {
        case 200...299: return .success("success")
        case 401...499: return .failure(NetworkingError.authenticationError)
        case 501...599: return .failure(NetworkingError.badRequest)
        case 600: return .failure(NetworkingError.outdated)
        default:
            return .failure(NetworkingError.failed)
        }
    }
    
    func getUsers(count: Int, page: Int, seed: String, completion: @escaping (Result<[UserModel]>) -> ()) {
        guard hasConnection else { completion(.failure(NetworkingError.noInternerConnection))
            return
        }
        router.request(.getUsers(count: count, page: page, seed: seed)) { (data, response, error) in
            if error != nil {
                completion(.failure(NetworkingError.noInternerConnection))
                return
            }
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .failure(let error):
                    completion(.failure(error))
                case .success(_):
                    guard let responseData = data else {
                        completion(.failure(NetworkingError.noData))
                        return
                    }
                    
                    do {
                        NetworkLogger.log(responseData: responseData)
                        let apiResponse = try JSONDecoder().decode(ResponseModel.self, from: responseData)
                        DispatchQueue.main.async {
                            guard apiResponse.error == nil else {
                                completion(.failure(NetworkingError.apiIsUnreachable))
                                return
                            }
                            completion(.success(apiResponse.results!))
                        }
                    } catch let error {
                        DispatchQueue.main.async {
                            completion(.failure(error))
                        }
                    }
                }
                
            }
        }
    }
    
}



