//
//  RandomUserEndPoint.swift
//  ATestsAssignment
//
//  Created by Vitalii Shkliar on 4/6/19.
//  Copyright © 2019 Vitalii Shkliar. All rights reserved.
//

import Foundation

enum RandomUserEndPoint: EndPointType {
   
    
    case getUsers(count: Int, page: Int, seed: String)
}

extension RandomUserEndPoint {
    var baseURL: URL {
        guard let url = URL(string: "https://randomuser.me") else { fatalError("baseURL could not be configured.")}
        return url
    }
    
    var path: String {
        switch self {
        default: return "/api/"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        default: return .get
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .getUsers(let count, let page, let seed):
            return .requestParameters(bodyParameters: nil,
                                      urlParameters: [ "page" : page,
                                                       "results" : count,
                                                       "seed" : seed])
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        default: return nil
        }
    }
}
