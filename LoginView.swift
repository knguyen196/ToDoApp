//
//  LoginView.swift
//  ToDoApp
//
//  Created by Jeffrey Wong on 5/6/25.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var auth = UserAuth()
    @State private var username = ""
    @State private var password = ""
    @State private var loginFailed = false
    @State private var showSignUp = false
    
    var body: some View {
        if auth.isAuthenticated {
            TabbedContentView()
        } else {
            VStack(spacing: 20) {
                Text("Login")
                    .font(.largeTitle)
                    .bold()
                
                TextField("Username", text: $username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                if loginFailed {
                    Text("Invalid credentials. Try again")
                        .foregroundStyle(.red)
                }
                
                Button("Log In") {
                    if auth.login(username: username, password: password) {
                        loginFailed = false
                    } else {
                        loginFailed = true
                    }
                    
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
                
                Button ("Sign Up") {
                    showSignUp = true
                }
                .padding(.top)
            }
            .padding()
            .sheet(isPresented: $showSignUp) {
                SignUpView(auth: auth)
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
