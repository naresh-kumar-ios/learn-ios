//
//  LoginServiceProvider.swift
//  LearniOS
//
//  Created by Naresh on 21/02/24.
//

import Foundation

public protocol LoginServiceProvider: AnyObject {
    func login(with loginRequestModel: LoginRequestModel) async throws -> LoginResponseModelNew
}
