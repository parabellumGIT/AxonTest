//
//  NetworkError.swift
//  ATestsAssignment
//
//  Created by Vitalii Shkliar on 4/6/19.
//  Copyright © 2019 Vitalii Shkliar. All rights reserved.
//

import Foundation

enum NetworkingError: Error {
    case authenticationError
    case badRequest
    case outdated
    case failed
    case noData
    case unableToDecode
    case noInternerConnection
    case apiIsUnreachable
}

extension NetworkingError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .noData: return "No data in response"
        case .badRequest: return "Bad request"
        case .unableToDecode: return "Unable to decode response"
        case .noInternerConnection: return "No internet connection"
        case .apiIsUnreachable: return "API is unreachable"
        default: return "Something went wrong"
        }
    }
}
