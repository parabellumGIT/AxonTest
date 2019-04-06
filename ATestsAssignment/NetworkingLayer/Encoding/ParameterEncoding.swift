//
//  ParameterEncoding.swift
//  Mawi
//
//  Created by ParaBellum on 5/20/18.
//  Copyright © 2018 yuravake. All rights reserved.
//

import Foundation
public typealias Parameters = [String:Any]
protocol ParameterEncoder {
    static func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws
}

enum NetworkError: String, Error {
    case parametersNil = "Parameters were nil"
    case encodingFailed = "Parameter encoding fail"
    case missingURL = "URL is nil."
}
