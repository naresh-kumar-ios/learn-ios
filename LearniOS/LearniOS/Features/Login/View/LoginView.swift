//
//  LoginView.swift
//  LearniOS
//
//  Created by Naresh on 09/01/24.
//

import SwiftUI

struct LoginView: View {

    @State var username: String = ""
    @State var password: String = ""

    var body: some View {
        VStack {
            Text("LOGIN")
                .font(.largeTitle)
            
            TextField(text: $username) {
                Text("User name")
            }
            .keyboardType(.emailAddress)
            .frame(height: 44)
            Divider()
            
            SecureField(text: $password) {
                Text("Password")
            }
            .keyboardType(.asciiCapable)
            .frame(height: 44)
            Divider()

            Button("Login") {
                
            }
            .padding(.top, 20)
            .frame(height: 44)
        }
        .padding()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
