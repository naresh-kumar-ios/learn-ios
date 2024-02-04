//
//  LoginViewStore.swift
//  LearniOS
//
//  Created by Naresh on 28/12/23.
//

import Foundation
import Combine

public enum LoginError: Error {
    case dataNotFound
    case someOtherError
}

public protocol LoginViewStoreDelegate {
    func loggedInSuccessFully()
}

public class LoginViewStore: ObservableObject {
    
    @Published var username: String = "kminchelle"
    
    @Published var password: String = "0lelplR"
    
    @Published var showError: Bool = false
        
    @Published var loading: Bool = false
        
    var delegate: LoginViewStoreDelegate?
    
    var message: String = ""
    
    public init(delegate: LoginViewStoreDelegate?) {
        self.delegate = delegate
    }
    
    public func login() {

        guard let loginRequestModel = LoginRequestModel(email: username, password: password) else {
            print("Can't build the request as password might empty")
            message = "Username or password can't be left blank"
            return
        }
        loading = true
        Task {
            do {
                let data = try await SessionManager.shared.dataTask(route: LoginRoute.login(loginRequestModel), responseType: LoginResponseModelNew.self)
                print("firstName - ", data.firstName ?? "")
                print("lastName - ", data.lastName ?? "")
                print("id - ", data.id)
                print("gender - ", data.gender ?? "")
                print("image - ", data.image ?? "")
                print("token - ", data.token)
                DispatchQueue.main.async { [weak self] in
                    self?.loading = false
                    self?.delegate?.loggedInSuccessFully()
                }
            } catch {
                DispatchQueue.main.async { [weak self] in
                    self?.loading = false
                    self?.showError = true
                    self?.message = error.localizedDescription
                }
            }
        }
    }
    
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

