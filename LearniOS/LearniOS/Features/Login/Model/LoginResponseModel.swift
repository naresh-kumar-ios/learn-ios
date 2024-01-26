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
