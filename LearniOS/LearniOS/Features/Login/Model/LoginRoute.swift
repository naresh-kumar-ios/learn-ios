//
//  LoginRoute.swift
//  LearniOS
//
//  Created by Naresh on 26/01/24.
//

import Foundation

public enum LoginRoute: SessionRoute {
    
    case login(LoginRequestModel)
    
    public var method: MethodType {
        switch self {
        case .login(_):
            return .post
        }
    }
    
    public var path: String {
        switch self {
        case .login(_):
            return "/auth/login"
        }
    }
    
    public var headers: [String : String]? {
        switch self {
        case .login(_):
            return ["Content-Type": "application/json"]
        }
    }
    
    public var parameters: [String : Any]? {
        switch self {
        case .login(let loginRequestModel):
            return ["username": loginRequestModel.email, "password": loginRequestModel.password]
        }
    }
    
    public var queryParams: [String : String]? {
        switch self {
        case .login:
            return nil
        }
    }    
}
