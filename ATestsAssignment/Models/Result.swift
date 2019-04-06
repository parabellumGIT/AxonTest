//
//  Results.swift
//  ATestsAssignment
//
//  Created by Vitalii Shkliar on 4/6/19.
//  Copyright © 2019 Vitalii Shkliar. All rights reserved.
//

import Foundation

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
