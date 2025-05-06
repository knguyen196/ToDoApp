//
//  SignUpView.swift
//  ToDoApp
//
//  Created by Jeffrey Wong on 5/6/25.
//

import SwiftUI

struct SignUpView: View {
    @ObservedObject var auth: UserAuth
    @Environment(\.dismiss) var dismiss
    @State private var username = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var errorMessage = ""

    var body: some View {
        VStack(spacing: 20) {
            Text("Create Account")
                .font(.title)

            TextField("Username", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            SecureField("Confirm Password", text: $confirmPassword)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
            }

            Button("Register") {
                if password != confirmPassword {
                    errorMessage = "Passwords do not match"
                } else if username.isEmpty || password.isEmpty {
                    errorMessage = "All fields are required"
                } else {
                    auth.register(username: username, password: password)
                    dismiss()
                }
            }
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(8)

            Spacer()
        }
        .padding()
    }
}
