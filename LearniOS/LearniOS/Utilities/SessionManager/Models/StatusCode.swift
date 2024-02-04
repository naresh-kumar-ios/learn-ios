//
//  StatusCode.swift
//  LearniOS
//
//  Created by Naresh on 27/01/24.
//

import Foundation

/// Here we will define the status code as per the server configuration, like 200 for success, 401 for unauthorised access. You may ask your backend team and update the code if required.
public enum StatusCode: Int {
    case success = 200
    case invalidCredential = 400
    case badRequest = 403
    case serverError = 503
}
