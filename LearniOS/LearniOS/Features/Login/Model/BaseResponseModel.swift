//
//  BaseResponseModel.swift
//  LearniOS
//
//  Created by Naresh on 20/01/24.
//

import Foundation

public struct BaseResponseModel<T: Codable>: Codable {
    var code: Int
    var message: String
    var data: T?
    
    private enum CodingKeys: CodingKey {
        case code
        case message
        case data
    }
    
    public init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<BaseResponseModel<T>.CodingKeys> = try decoder.container(keyedBy: BaseResponseModel<T>.CodingKeys.self)
        /// From server the code can come as String or Int
        var codeInt = try? container.decode(Int.self, forKey: .code)
        if codeInt == nil {
            let codeString = try? container.decode(String.self, forKey: .code)
            codeInt = Int(codeString ?? "")
        }
        /// If no code found then set to -1
        self.code = codeInt ?? -1
        self.message = try container.decode(String.self, forKey: .message)
        self.data = try? container.decode(T.self, forKey: .data)
    }
}
