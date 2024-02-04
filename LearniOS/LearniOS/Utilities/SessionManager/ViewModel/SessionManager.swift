//
//  ApiServiceManager.swift
//  LearniOS
//
//  Created by Naresh on 26/01/24.
//

import Foundation

final public class SessionManager: NSObject {
    
    /// This is the singleton instance of this class
    public static var shared = SessionManager()
    /// The shared session
    private var session: URLSession
    /// Configuration
    private var configuration: URLSessionConfiguration
    /// After one minute the api will return timeout error
    private var timeout: TimeInterval = 60
    /// This enviroment must be fetched from the current scheme we are running. As of now we are hardcoding this.
    private var enviroment: Enviroment
    private let waitsForConnectivity: Bool = true
    
    /// This will make this class as the singlton
    private override init() {
        /// ephemeral - a session configuration that uses no persistent storage for caches, cookies, or credentials.
        configuration = URLSessionConfiguration.ephemeral
        configuration.timeoutIntervalForRequest = timeout
        configuration.waitsForConnectivity = waitsForConnectivity
        session = URLSession.init(configuration: configuration)
        enviroment = .dev
    }
    
    /// This function will hit api and return the response in provided format
    /// - Parameters:
    ///   - route: api route information
    ///   - responseType: response type
    /// - Returns: desription
    public func dataTask<T: Codable>(route: SessionRoute, responseType: T.Type) async throws -> T {
        
        let urlRequest: URLRequest = try route.urlRequest(baseUrl: self.enviroment.baseUrl)
        let (data, response) = try await session.data(for: urlRequest, delegate: self)
        guard let httpStatusCode = (response as? HTTPURLResponse)?.statusCode else {
            /// We didn't get the status code at all
            throw SessionError.somethingWendWrong
        }
        print("httpStatusCode - ", httpStatusCode)
        guard let statusCode = StatusCode(rawValue: httpStatusCode) else {
            /// Status code is something else.
            throw SessionError.somethingWendWrong
        }
        switch statusCode {
        case .success:
            if !data.isEmpty {
                return try JSONDecoder().decode(T.self, from: data)
            } else {
                throw SessionError.parsingError
            }
        case .invalidCredential:
            throw SessionError.invalidCredential
        case .badRequest, .serverError:
            throw SessionError.somethingWendWrong
        }
    }
    
    private func printJson(from data: Data) {
        if let json = try? JSONSerialization.jsonObject(with: data) {
            print("Response data - ", json)
        }
    }
}

//MARK: - URLSessionTaskDelegate -

extension SessionManager: URLSessionTaskDelegate {
    
    public func urlSession(_ session: URLSession, didCreateTask task: URLSessionTask) {
        print(#function, " URL - ", task.originalRequest?.url ?? "-/-")
    }
    
    public func urlSession(_ session: URLSession, taskIsWaitingForConnectivity task: URLSessionTask) {
        print(#function, " URL - ", task.originalRequest?.url ?? "-/-")
    }
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        print(#function, " URL - ", task.originalRequest?.url ?? "-/-")
        print(" bytesSent - ", bytesSent, " totalBytesSent - ", totalBytesSent)
    }
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, didReceiveInformationalResponse response: HTTPURLResponse) {
        print(#function, " URL - ", task.originalRequest?.url ?? "-/-")
        print("statusCode - ", response.statusCode)
    }
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, didFinishCollecting metrics: URLSessionTaskMetrics) {
        print(#function, " URL - ", task.originalRequest?.url ?? "-/-")
    }
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        print(#function, " URL - ", task.originalRequest?.url ?? "-/-")
    }
}
