//
//  LoginRequestModel.swift
//  LearniOS
//
//  Created by Naresh on 28/12/23.
//

import Foundation

public struct loginRequestModel {
    var email: String
    var password: String
    
    init?(email: String, password: String) {
        /// don't initialise if the email or password is empty
        guard !email.isEmpty && !password.isEmpty else { return nil }
        self.email = email
        self.password = password
    }
}
