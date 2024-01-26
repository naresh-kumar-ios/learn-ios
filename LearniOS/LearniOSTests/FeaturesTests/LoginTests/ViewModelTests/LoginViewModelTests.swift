//
//  LoginViewModelTests.swift
//  LearniOSTests
//
//  Created by Naresh on 28/12/23.
//

import XCTest
@testable import LearniOS

final class LoginViewModelTests: XCTestCase {
    
    var loginViewModel: LoginViewModel!
    var parser: Parser?
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        loginViewModel = LoginViewModel()
        parser = Parser()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        loginViewModel = nil
        parser = nil
    }
    
    func testLoginResponseParsing() throws {
        let data = try self.parser?.read(fileName: "baseResponseWithoutData", ext: "json")
        XCTAssertNotNil(data)
        do {
            let loginResponse = try self.loginViewModel?.parseLoginResponseFrom(data: data!)
            XCTAssertNotNil(loginResponse)
        } catch {
            if let error = error as? LoginError, error == LoginError.dataNotFound {
                XCTAssert(true, "Function is thoring the correct error")
            } else {
                XCTAssert(false, "Function is not thoring the correct error")
            }
        }
    }
    
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
