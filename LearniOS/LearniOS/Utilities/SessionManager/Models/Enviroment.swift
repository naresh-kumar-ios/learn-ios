//
//  ApiSessionType.swift
//  LearniOS
//
//  Created by Naresh on 26/01/24.
//

import Foundation

@frozen public enum Enviroment {
    
    case dev
    case stage
    case demo
    case release
    
    var baseUrl: String {
        switch self {
        case .dev:
            return "https://dummyjson.com"
        case .stage:
            return ""
        case .demo:
            return ""
        case .release:
            return ""
        }
    }
}
