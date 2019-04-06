//
//  UserDetailsVCViewModel.swift
//  ATestsAssignment
//
//  Created by Vitalii Shkliar on 4/6/19.
//  Copyright © 2019 Vitalii Shkliar. All rights reserved.
//

import Foundation

final class UserDetailsVCViewModel: ViewModelProtocol {
    let userVM: UserViewModel
    
    init(with user: UserModel) {
        self.userVM = UserViewModel(from: user, imageType: .large)
    }
}
