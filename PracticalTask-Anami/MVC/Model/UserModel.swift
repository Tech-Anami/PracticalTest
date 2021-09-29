//
//  UserModel.swift
//  PracticalTask-Anami
//
//  Created by Anami on 29/09/21.
//

import Foundation

struct UserDataModel: Codable {
    var data: UserModel?
}

struct UserModel: Codable {
    var id: Int?
    var bio, gender, first_name, image_url, location: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case bio = "bio"
        case gender = "gender"
        case first_name = "first_name"
        case image_url = "image_url"
        case location = "location"
    }
}
