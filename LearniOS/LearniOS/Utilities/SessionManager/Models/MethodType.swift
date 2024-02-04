//
//  ApiMethod.swift
//  LearniOS
//
//  Created by Naresh on 27/01/24.
//

import Foundation

/// Api methid type.
public enum MethodType: String, CaseIterable {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}
