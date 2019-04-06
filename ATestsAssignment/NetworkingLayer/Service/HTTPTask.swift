//
//  HTTPTask.swift
//  Mawi
//
//  Created by ParaBellum on 5/20/18.
//  Copyright © 2018 yuravake. All rights reserved.
//

import Foundation
public typealias HTTPHeaders = [String:String]

enum HTTPTask {
    case request
    case requestParameters(bodyParameters: Parameters?, urlParameters: Parameters?)
    case requestParametersAndHeaders(bodyParameters: Parameters?, urlParameters: Parameters?, additionHeaders: HTTPHeaders?)
}
