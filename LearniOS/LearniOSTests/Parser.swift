//
//  Parser.swift
//  LearniOSTests
//
//  Created by Naresh on 20/01/24.
//

import Foundation

public class Parser {
    
    public init() { }
    
    func read(fileName: String, ext: String) throws -> Data {
        guard let url = Bundle(for: Self.self)
                    .url(forResource: fileName, withExtension: ext) else {
            throw ParsingError.fileNotFound
        }
        return try Data(contentsOf: url)
    }
}

public enum ParsingError: Error {
    case fileNotFound
}
