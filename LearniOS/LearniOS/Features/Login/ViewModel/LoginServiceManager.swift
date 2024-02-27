//
//  LoginApiServiceProvider.swift
//  LearniOS
//
//  Created by Naresh on 21/02/24.
//

import Foundation

final public class LoginServiceManager: LoginServiceProvider {
    
    public func login(with loginRequestModel: LoginRequestModel) async throws -> LoginResponseModelNew {
        let data = try await SessionManager.shared.dataTask(route: LoginRoute.login(loginRequestModel), responseType: LoginResponseModelNew.self)
        return data
    }
}
