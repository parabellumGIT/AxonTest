//
//  UserDetailsVCViewModel.swift
//  ATestsAssignment
//
//  Created by Vitalii Shkliar on 4/6/19.
//  Copyright © 2019 Vitalii Shkliar. All rights reserved.
//

import Foundation

enum CallNumberType {
    case cell, phone
}

final class UserDetailsVCViewModel: ViewModelProtocol {
    let userVM: UserViewModel
    var onError: ((String) -> Void)?
    
    
    func call(numberType: CallNumberType) {
        let number = numberType == .cell ? userVM.cellNumber! : userVM.phoneNumber!
        number.makeACall {[weak self] (result) in
            switch result {
            case .failure(_):
               self?.onError?("Not a valid number")
            case .success(_):
                break
            }
        }
    }
    
    init(with user: UserModel) {
        self.userVM = UserViewModel(from: user, imageType: .large)
    }
}
