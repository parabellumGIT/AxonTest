//
//  NetworkRourer.swift
//  Mawi
//
//  Created by ParaBellum on 5/20/18.
//  Copyright © 2018 yuravake. All rights reserved.
//

import Foundation
typealias NetworkRouterCompletion = (_ data: Data?,_ response: URLResponse?,_ error: Error?) -> ()
protocol NetworkRouter: class  {
    associatedtype EndPoint: EndPointType
    func request(_ route: EndPoint, completion: @escaping NetworkRouterCompletion)
    func cancel()
}
