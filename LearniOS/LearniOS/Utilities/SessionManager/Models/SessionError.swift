//
//  SessionError.swift
//  LearniOS
//
//  Created by Naresh on 26/01/24.
//

import Foundation

/// These are the errors we can throw from api function if any sepecified condition met.
public enum SessionError: Error {
    case parsingError
    case invalidRequest
    case somethingWendWrong
    case invalidCredential
    
    /// Here we will specify the message we need to show to the end user. The localisation can also be done here if needed.
    var message: String {
        switch self {
        case .parsingError:
            return "The data is not in the correct format. Kindly try agian later"
        case .invalidRequest:
            return "The invalid requiest, one or more entery might be wrongly entered"
        case .somethingWendWrong:
            return "Somethihg went wrong, please try again later"
        case .invalidCredential:
            return "Username / email or password might be wrong"
        }
    }
}
