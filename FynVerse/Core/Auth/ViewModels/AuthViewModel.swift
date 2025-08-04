//
//  AuthViewModel.swift
//  FynVerse
//
//  Created by zubair ahmed on 13/07/25.
//

import Foundation
import SwiftUI
@MainActor
final class AuthViewModel: ObservableObject {
    @Published  var user : DBUser? = nil
    @Published var email = ""
    @Published var password = ""
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    @Published var isLoading: Bool = false

    func signUp() async throws {
        guard !email.isEmpty, !password.isEmpty else { return }
        
       let authDataResult =  try await AuthService.shared.createUser(email: email, password: password)
        let user = DBUser(auth: authDataResult)
        try await UserManager.shared.createNewUser(user: user)
        isLoggedIn = true
    }
    func checkAuthStatus() {
            isLoggedIn = (try? AuthService.shared.getAuthenticatedUser()) != nil
        }
    func loadCurrentUser() async throws {
        self.isLoading = true
        defer { self.isLoading = false }

        let authDataResult = try AuthService.shared.getAuthenticatedUser()
        if let user = try await UserManager.shared.getUser(userID: authDataResult.uid) {
            self.user = user
        } else {
            print("No user found in Firestore.")
        }
    }    
}

extension AuthViewModel {
    //SettingsViewModel
    func logout() {
        
        do {
            try AuthService.shared.signOut()
            isLoggedIn = false
            
        } catch {
            print("Logout error:", error)
        }
    }
    
    func resetPassword() async throws {
        
        let authUser = try AuthService.shared.getAuthenticatedUser()
        guard let email = authUser.email else {
            throw URLError(.fileDoesNotExist)
        }
        try await AuthService.shared.resetPassword(email: email)
    }
    
    func updatePassword() async throws {
        
        try await AuthService.shared.updatePassword(password: "New Pass")
    }
    
    
    func delete() async throws{
        try await AuthService.shared.delete()
    }
}

extension AuthViewModel {
    //AutgenticationViewModel
    func logIn() async throws {
        guard !email.isEmpty, !password.isEmpty else { return }
        
        _ = try await AuthService.shared.signInUser(email: email, password: password)
        isLoggedIn = true
    }
    
    //SignInWithGoogle

    func signInGoogle() async throws {
        let helper = SignInGoogleHelper()
        let tokens = try await helper.signIn()
        // 5. Delegate to AuthService
        let authDataResult = try await AuthService.shared.signInWithGoogle(tokens: tokens)
        let user = DBUser(auth: authDataResult)
        try await UserManager.shared.createNewUser(user: user)
        //try await UserManager.shared.createNewUser(Auth: authDataResult)
        isLoggedIn = true
        
    }

}
