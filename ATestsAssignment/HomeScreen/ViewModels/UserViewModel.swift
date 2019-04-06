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
    var birthday: String?
    let cellNumber: String?
    let phoneNumber: String?
    let imageUrl: URL
    let name: String
    let lastName: String
    let gender: String
    
    init(from userModel: UserModel, imageType: ImageType) {
        fullName = "\(userModel.firstName) \(userModel.lastName)"
        name = userModel.firstName
        lastName = userModel.lastName
        gender = userModel.isMale ? "Male" : "Female"
        let dateFormatter = DateFormatter()
        let format = DateFormatter.dateFormat(fromTemplate: "MMMdd", options: 0, locale: Locale.current) ?? "MMM dd"
        dateFormatter.dateFormat = format
        if let date = userModel.birthdayDate {
            birthday = dateFormatter.string(from: date)
        }
        switch imageType {
        case .large: imageUrl = URL(string: userModel.picture.large)!
        case .medium: imageUrl = URL(string: userModel.picture.medium)!
        case .thumb: imageUrl = URL(string: userModel.picture.thumbnail)!
        }
        cellNumber = userModel.cell
        phoneNumber = userModel.phone
    }
}
