//
//  LoginView.swift
//  LearniOS
//
//  Created by Naresh on 09/01/24.
//

import SwiftUI

/**
 
username: 'kminchelle',
password: '0lelplR',
 
 */

struct LoginView: View {

    @EnvironmentObject var store: LoginViewStore
    
    var body: some View {
        ZStack {
            /// Showing the loading
            if store.loading {
                /// show the loading when this loading property is true
                ProgressView()
            }
            /// Showing the Loging view
            VStack {
                Text("LOGIN")
                    .font(.largeTitle)
                
                TextField(text: $store.username) {
                    Text("User name")
                }
                .keyboardType(.emailAddress)
                .frame(height: 44)
                Divider()
                
                SecureField(text: $store.password) {
                    Text("Password")
                }
                .keyboardType(.asciiCapable)
                .frame(height: 44)
                Divider()

                Button("Login") {
                    store.login()
                }
                .padding(.top, 20)
                .frame(height: 44)
            }
            
        }
        .padding()
        .alert(store.message, isPresented: $store.showError) {
            Button("OK") {
                print("Error alert ok button presssed")
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
