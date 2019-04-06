//
//  AlertRepresentable.swift
//  ATestsAssignment
//
//  Created by Vitalii Shkliar on 4/6/19.
//  Copyright © 2019 Vitalii Shkliar. All rights reserved.
//
import Foundation
import UIKit

typealias Completion = () -> ()

protocol ErrorRepresentable: class {
     func showError(title: String?, text: String, completion: Completion?)
}

extension ErrorRepresentable where Self: UIViewController {
    func showError(title: String? = nil, text: String, completion: Completion? = nil) {
        let alertController = UIAlertController(title: title, message: text, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
            completion?()
        }))
        self.present(alertController, animated: true, completion: nil)
    }
}
