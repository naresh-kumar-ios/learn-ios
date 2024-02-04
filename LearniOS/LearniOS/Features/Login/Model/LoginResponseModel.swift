//
//  LoginResponseModel.swift
//  LearniOS
//
//  Created by Naresh on 20/01/24.
//

import Foundation

public struct LoginResponseModel: Codable {
    var accessToken: String
    var refreshToken: String
    var userDetail: UserDetailModel
}

public struct UserDetailModel: Codable {
    var id: String
    var firstName: String?
    var lastName: String?
    var image: String?
}

public struct LoginResponseModelNew: Codable {
    var id: Int
    var username: String
    var email: String
    var firstName: String?
    var lastName: String?
    var gender: String?
    var image: String?
    var token: String
}
