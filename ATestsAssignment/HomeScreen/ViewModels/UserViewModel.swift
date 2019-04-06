//
//  UserViewModel.swift
//  ATestsAssignment
//
//  Created by Vitalii Shkliar on 4/6/19.
//  Copyright © 2019 Vitalii Shkliar. All rights reserved.
//

import Foundation

enum ImageType {
    case large, medium, thumb
}

struct UserViewModel {
    let fullName: String
    var cellNumber: String?
    var phoneNumber: String?
    let imageUrl: URL
    let name: String
    let lastName: String
    let gender: String
    let age: String
    
    private let birthdayDate: Date?
    
    var birthDay: String {
        guard let date = birthdayDate else {
            return "---"
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        return dateFormatter.string(from: date)
    }
    
    init(from userModel: UserModel, imageType: ImageType) {
        fullName = "\(userModel.firstName) \(userModel.lastName)"
        name = userModel.firstName
        lastName = userModel.lastName
        gender = userModel.isMale ? "Male" : "Female"
        age = String(userModel.age)
        birthdayDate = userModel.birthdayDate
        switch imageType {
        case .large: imageUrl = URL(string: userModel.picture.large)!
        case .medium: imageUrl = URL(string: userModel.picture.medium)!
        case .thumb: imageUrl = URL(string: userModel.picture.thumbnail)!
        }
        if let cell = userModel.cell {
             cellNumber = String.format(phoneNumber: cell)
        }
        if let phone = userModel.phone {
             phoneNumber = String.format(phoneNumber: phone)
        }
    }
}
