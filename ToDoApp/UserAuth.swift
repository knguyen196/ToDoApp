//
//  UserAuth.swift
//  ToDoApp
//
//  Created by Jeffrey Wong on 5/6/25.
//

import Foundation

class UserAuth: ObservableObject {
    @Published var isAuthenticated = false

    private let usernameKey = "savedUsername"
    private let passwordKey = "savedPassword"

    func register(username: String, password: String) {
        UserDefaults.standard.set(username, forKey: usernameKey)
        UserDefaults.standard.set(password, forKey: passwordKey)
        isAuthenticated = true
    }

    func login(username: String, password: String) -> Bool {
        let savedUsername = UserDefaults.standard.string(forKey: usernameKey)
        let savedPassword = UserDefaults.standard.string(forKey: passwordKey)

        if username == savedUsername && password == savedPassword {
            isAuthenticated = true
            return true
        } else {
            return false
        }
    }

    func isUserRegistered() -> Bool {
        return UserDefaults.standard.string(forKey: usernameKey) != nil
    }

    func logout() {
        isAuthenticated = false
    }
}
