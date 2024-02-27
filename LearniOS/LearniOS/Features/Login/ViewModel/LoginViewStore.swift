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
    case invalidCredentails
}

public protocol LoginViewStoreDelegate {
    func loggedInSuccessFully()
}

public class LoginViewStore: ObservableObject {
    
    @Published var username: String = ""
    
    @Published var password: String = ""
    
    @Published var showError: Bool = false
        
    @Published var loading: Bool = false
        
    var delegate: LoginViewStoreDelegate?
    
    var message: String = ""
    
    private var loginServiceProvider: LoginServiceProvider
    
    public init(delegate: LoginViewStoreDelegate?, loginServiceProvider: LoginServiceProvider) {
        self.loginServiceProvider = loginServiceProvider
        self.delegate = delegate
    }
    
    /// This function will check if the user name and password are non empty then pass that to apu module else update the published variable to show an error.
    /// - Parameter completion: This completion block is optional to indicate the end of the task.
    public func login(_ completion: (() -> Void)? = nil) {

        guard let loginRequestModel = LoginRequestModel(email: username, password: password) else {
            print("Can't build the request as password might empty")
            self.showError = true
            message = Constants.Messages.emptyPassword.rawValue
            return
        }
        /// This statement would update the UI to show the loader.
        loading = true
        Task {
            do {
                let data = try await self.loginServiceProvider.login(with: loginRequestModel)
                DispatchQueue.main.async { [weak self] in
                    /// This statement would update the UI to hide the loader.
                    self?.loading = false
                    /// This statement would update the AppRoute to set the product list view as main view
                    self?.delegate?.loggedInSuccessFully()
                    /// This statement indicate the login function have been completed
                    completion?()
                }
            } catch {
                DispatchQueue.main.async { [weak self] in
                    /// This statement would update the UI to hide the loader.
                    self?.loading = false
                    /// This statement would show an error alert  to the user
                    self?.message = error.localizedDescription
                    /// This statement would show an error alert  to the user
                    self?.showError = true
                    /// This statement indicate the login function have been completed
                    completion?()
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

