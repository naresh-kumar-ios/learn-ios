//
//  LoginServiceManagerMock.swift
//  LearniOSTests
//
//  Created by Naresh on 21/02/24.
//

import Foundation
@testable import LearniOS

public class LoginServiceManagerMock: LoginServiceProvider {
    /// This is the mock function equivalent to the login api function.
    /// - Parameter loginRequestModel: The request model having email and the password
    /// - Returns: LoginResponseModelNew response object.
    public func login(with loginRequestModel: LoginRequestModel) async throws -> LoginResponseModelNew {
        /// Hardcoded username and password for those we will send some mock response from JSON file
        if loginRequestModel.email == "kminchelle" && loginRequestModel.password == "0lelplR" {
            /// Success case
            var parser = Parser()
            let data = try parser.read(fileName: "loginSuccess", ext: "json")
            let loginResponse = try JSONDecoder().decode(LoginResponseModelNew.self, from: data)
            return loginResponse
        } else {
            /// failure case
            throw LoginError.invalidCredentails
        }
    }
}
