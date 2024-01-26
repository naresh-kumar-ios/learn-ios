//
//  LoginViewModel.swift
//  LearniOS
//
//  Created by Naresh on 28/12/23.
//

import Foundation
import SwiftUI

public enum LoginError: Error {
    case dataNotFound
    case someOtherError
}

public class LoginViewModel {
    
    public init() { }
    
/// This function will convert the Data into LoginResponseModel, it can throw error if anything wrong happened.
/// - Parameter data: The raw data which we need to parse.
/// - Returns: LoginResponseModel object
public func parseLoginResponseFrom(data: Data) throws -> LoginResponseModel {
    let baseResponse = try JSONDecoder().decode(BaseResponseModel<LoginResponseModel>.self, from: data)
    guard let data = baseResponse.data else {
        throw LoginError.dataNotFound
    }
    return data
}
    
    /// This function will validate the user email address
    /// - Parameter email: email that we need to validate
    /// - Returns: Boolean result true is it's a valid email else false
    public func isValid(email: String) -> Bool {
        guard !email.isEmpty else { return false }
        
        /// Here is the logic to validate the email address
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        return regex.firstMatch(in: email, options: [], range: NSRange(location: 0, length: email.count)) != nil
    }
}

