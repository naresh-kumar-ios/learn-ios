//
//  SessionRoute.swift
//  LearniOS
//
//  Created by Naresh on 26/01/24.
//

import Foundation

/// This protocol must be confirmed by an enum. Becase in an enum each case would corresponds to the api endpoint, for each endpoint (enum case) we have to provide the following information
public protocol SessionRoute {
    var method: MethodType { get }
    var path: String { get }
    var headers: [String: String]? { get }
    var parameters: [String: Any]? { get }
    var queryParams: [String: String]? { get }
    
    /// This will build the api request
    func urlRequest(baseUrl: String) throws -> URLRequest 
}

// MARK: - Building Request -
extension SessionRoute {
    /// This function will build the api request from ApiRoute protocol
    /// - Parameter route: The api route which provide the network related information
    /// - Returns: URLRequest
    public func urlRequest(baseUrl: String) throws -> URLRequest {
        
        /// Create the url from the base url & url endpoint first
        guard let url = URL(string: (baseUrl + self.path)) else {
            throw SessionError.invalidRequest
        }
        var urlRequest = URLRequest.init(url: url)
        urlRequest.httpMethod = self.method.rawValue
        urlRequest.allHTTPHeaderFields = self.headers
        if let params = self.parameters {
            do {
                let data = try JSONSerialization.data(withJSONObject: params)
                urlRequest.httpBody = data
            } catch {
                throw error
            }
        }
        
        if let queryParams = self.queryParams {
            /// Adding the default parameters
            var items: [URLQueryItem] = []
            for key in queryParams.keys {
                let item = URLQueryItem.init(name: key, value: queryParams[key])
                items.append(item)
            }
            urlRequest.url?.append(queryItems: items)
        }
        return urlRequest
    }
}
