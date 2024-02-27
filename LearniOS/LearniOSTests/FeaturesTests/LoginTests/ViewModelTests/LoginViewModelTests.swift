//
//  LoginViewModelTests.swift
//  LearniOSTests
//
//  Created by Naresh on 28/12/23.
//

import XCTest
@testable import LearniOS

final class LoginViewModelTests: XCTestCase {
    
    var loginViewModel: LoginViewStore!
    var parser: Parser?
    
    var expectaion: XCTestExpectation?
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        loginViewModel = LoginViewStore(delegate: self, loginServiceProvider: LoginServiceManagerMock())
        parser = Parser()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        loginViewModel = nil
        parser = nil
        expectaion = nil
    }
    
    /*func testLoginResponseParsing() throws {
        let data = try self.parser?.read(fileName: "baseResponseWithoutData", ext: "json")
        XCTAssertNotNil(data)
        do {
            let loginResponse = try self.loginViewModel?.parseLoginResponseFrom(data: data!)
            XCTAssertNotNil(loginResponse)
        } catch {
            if let error = error as? LoginError, error == LoginError.dataNotFound {
                XCTAssert(true, "Function is thoring the correct error")
            } else {
                print("error -- ", error.localizedDescription)
                XCTAssert(false, "Function is not thoring the correct error ")
            }
        }
    }*/
    
    //MARK: - Email Validation Test -
    func testIsValidEmail() {
        /// Case1 -- Empty string can't be a valid email address
        XCTAssertFalse(self.loginViewModel.isValid(email: ""))
        /// Here we can define the list of possible emails and the status those are valid or not.
        let emails: [(String, Bool)] = [
            ("  ", false),
            ("nare shk @ sdd.com", false),
            ("s@,com", false),
            (",@hsj.c", false),
            ("@socm.", false),
            ("narsh@shsn@hshs.com", false),
            ("naresh@ learn-ios", false),
            ("naresh@learn-ios.com", true),
            ("g@gmail.com", true),
            ("6@7.com", true)
        ]
        for (email, knownResult) in emails {
            let isValidEmail = loginViewModel.isValid(email: email)
            XCTAssertEqual(knownResult, isValidEmail, "Test case failed for string - \(email)")
        }
    }
}

// MARK: - HAPPY FLOW - LOGIN SHOULD SUCCEED -
extension LoginViewModelTests {
    /****
     This test function will make sure the following expections must be fulfilled
     1. The username should be empty initially
     2. The password should be empty initially
     3. Once user tap the login button after entering the correct detail then the loader should appear to user to indicate the processing.
     4. Once the processing completed the loader must be dismissed
     5. User should move to the production list screen.
     ***/
    func testUserLoginSuccessFlow() {
        /// Create a expectation as the same name of the function.
        expectaion = XCTestExpectation.init(description: #function)
        expectaion?.expectedFulfillmentCount = 5
        expectaion?.assertForOverFulfill = true
        
        /// Expectation 1 -- Initially the username must be empty
        if loginViewModel.username.isEmpty {
            expectaion?.fulfill(description: #function)
        }
        
        /// Expectation 2 -- Initially the password must be empty
        if loginViewModel.password.isEmpty {
            expectaion?.fulfill(description: #function)
        }
        /// Enterning the username and password.
        loginViewModel.username = "kminchelle"
        loginViewModel.password = "0lelplR"
        /// Tap on the login button
        loginViewModel.login { [weak self] in
            guard let self = self else {
                XCTAssert(true)
                return
            }
            /// Expectation 4 -- The loading indicator must be dismissed.
            if !self.loginViewModel.loading {
                self.expectaion?.fulfill(description: #function)
            }
            /// Expectation 5 -- The user must be direction to product list screen would be taken care in delegate call,
        }
        
        /// Expectation 3 -- On tap of login after enter the detail, there must be loading indicator.
        if self.loginViewModel.loading {
            expectaion?.fulfill(description: #function)
        }
        /// Since this is an async operation so let's wait for sometime, wait for 61 seconds because the api timeout is 60 second
        wait(for: [expectaion!], timeout: 5)
    }
}

// MARK: - EMPTY USERNAME or PASSWORD - LOGIN SHOULD FAILED WITH ERROR -
extension LoginViewModelTests {
    /****
     This test function will make sure the following flow must not be broken. Mean the following expectations must be fulfilled
     1. If either user name or password is empty and user tap the login button then
     2. Loader should not appear
     2. Error should appear to the user saying the message -- "Username or password can't be left blank"
     ***/
    func testUserLoginEmptyPasswordFlow() {
        /// Create a expectation as the same name of the function.
        expectaion = XCTestExpectation.init(description: #function)
        expectaion?.expectedFulfillmentCount = 3
        expectaion?.assertForOverFulfill = true
        
        loginViewModel.username = "kminchelle"
        loginViewModel.password = ""
    
        loginViewModel.login()
       
        /// Expectation 1 -- Loader should not appear
        if !loginViewModel.loading {
            expectaion?.fulfill(description: #function)
        }
        
        /// Expectation 2 -- Error should be shown to the user.
        if loginViewModel.showError {
            expectaion?.fulfill(description: #function)
        }
        
        /// Expectation 3 -- Error must have the same message as specified in the enum.
        if loginViewModel.message == Constants.Messages.emptyPassword.rawValue {
            expectaion?.fulfill(description: #function)
        }
        
        /// Since this will not make any api call so so let's wait for 2 seconds.
        wait(for: [expectaion!], timeout: 2)
    }
}

// MARK: - WRONG USERNAME or PASSWORD - LOGIN SHOULD FAILED WITH ERROR -
extension LoginViewModelTests {
    /****
     This test function will make sure the following flow must not be breaked
     1. The username should be empty initially
     2. The password should be empty initially
     3. Once user tap the login button after entering the incorrect detail then the loader should apear to user to indicate the processing.
     4. Once the processing completed the loader must be dissmissed
     5. User should get an error inccorrect username or password
     ***/
    func testUserLoginWrongCredentialFlow() {
        /// Create a expectation as the same name of the function.
        expectaion = XCTestExpectation.init(description: #function)
        expectaion?.expectedFulfillmentCount = 6
        expectaion?.assertForOverFulfill = true
        
        /// Expectation 1 -- Initially the username must be empty
        if loginViewModel.username.isEmpty {
            print(expectaion?.description ?? "-/-", " Fulfilled at line", #line)
            expectaion?.fulfill(description: #function)
        }
        /// Expectation 2 -- Initially the password must be empty
        if loginViewModel.password.isEmpty {
            print(expectaion?.description ?? "-/-", " Fulfilled at line", #line)
            expectaion?.fulfill(description: #function)
        }
        /// Entering the incconect detail
        loginViewModel.username = "kminchelle"
        loginViewModel.password = "someWrongPassword"
    
        loginViewModel.login { [weak self] in
            
            guard let self = self else { return }
            
            /// Expectation 4 -- The loader must be dismissed.
            if !loginViewModel.loading {
                print(expectaion?.description ?? "-/-", " Fulfilled at line", #line)
                expectaion?.fulfill(description: #function)
            }
            
            /// Expectation 5 -- The error flag should be enabled, means must shown as error to user.
            if loginViewModel.showError {
                print(expectaion?.description ?? "-/-", " Fulfilled at line", #line)
                expectaion?.fulfill(description: #function)
            }
            
            /// Expectation 6 -- The error must have some non empty message.
            if !loginViewModel.message.isEmpty {
                print(expectaion?.description ?? "-/-", " Fulfilled at line", #line)
                expectaion?.fulfill(description: #function)
            }
        }
        
        /// Expectation 3 -- On tap of login after enter the detail, there must be loading indicator.
        if loginViewModel.loading {
            print(expectaion?.description ?? "-/-", " Fulfilled at line", #line)
            expectaion?.fulfill(description: #function)
        }
        
        /// Since this is an async operation and need api call so let's wait till api timeout which is 60 seconds
        wait(for: [expectaion!], timeout: 61)
    }
}



extension LoginViewModelTests: LoginViewStoreDelegate {
    func loggedInSuccessFully() {
        /// Expectation 5 -- The user must be direction to product list screen would be taken care in delegate call,
        expectaion?.fulfill(description: "testUserLoginSuccessFlow()")
    }
}


extension XCTestExpectation {
    public func fulfill(description: String) {
        if self.description == description {
            self.fulfill()
        } else {
            print("Attampt to fulfill expectation having description -- ", description, " provided description - ", description)
        }
    }
}
