//
//  UserModel.swift
//  ATestsAssignment
//
//  Created by Vitalii Shkliar on 4/6/19.
//  Copyright © 2019 Vitalii Shkliar. All rights reserved.
//

import Foundation

struct ResponseModel: Decodable {
    let results: [UserModel]?
    let info: ResponseInfo?
    let error: String?
}

struct UserModel: Decodable {
    let firstName: String
    let lastName: String
    let isMale: Bool
    let phone: String?
    let cell: String?
    var birthdayDate: Date?
    let picture: Picture
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case birthdayObj = "dob"
        case picture = "picture"
        case gender = "gender"
        case phone = "phone"
        case cell = "cell"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let name = try container.decode([String : String].self, forKey: .name)
        firstName = name["first"] ?? "--"
        lastName = name["last"] ?? "--"
        let birthday = try container.decode(DateOfBirth.self, forKey: .birthdayObj)
        birthdayDate = dateFormatter.date(from: birthday.date)
        picture = try container.decode(Picture.self, forKey: .picture)
        let genderStr = try container.decode(String.self, forKey: .gender)
        isMale = genderStr == "male"
        phone = try container.decodeIfPresent(String.self, forKey: .phone)
        cell = try container.decodeIfPresent(String.self, forKey: .cell)
    }
    
}

struct Picture: Decodable {
    let large: String
    let medium: String
    let thumbnail: String
}

struct DateOfBirth: Decodable {
    let date: String
    let age: Int
}

struct ResponseInfo: Decodable {
    let seed: String
    let results: Int
    let page: Int
}

