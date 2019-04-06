//
//  NetworkLogger.swift
//  Mawi
//
//  Created by ParaBellum on 6/8/18.
//  Copyright © 2018 yuravake. All rights reserved.
//

import Foundation
import os.log

struct NetworkLogger {
    
    static func log(request: URLRequest) {
        if let url = request.url {
            print("Request URL---->\(url)")
        }
        if let headers = request.allHTTPHeaderFields {
            print( "Request HEADERS: ----> \(headers)")
        }
        if let data = request.httpBody {
            print("Request BODY: ----> \(String(data: data, encoding: .utf8)!)")
        }
        
        var data: String {
            if let data =  request.httpBody {
                return String(data: data, encoding: .utf8)!
            } else {
                return "--"
            }
        }
        
        
    }

    static func log(response: HTTPURLResponse) {
      
        print("Response STATUS CODE: --> \(response.statusCode)")
    }

    static func log(responseData data: Data){
        do {
        if let json =  try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String : Any] {
            print(json)
            }
        } catch {
            print("RESPONSE DATA CANNOT BE CONVERTED TO  a JSON")
        }
    }
    
}
