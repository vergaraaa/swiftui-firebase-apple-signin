//
//  AuthService.swift
//  FirebaseAppleSignIn
//
//  Created by Edgar Ernesto Vergara Montiel on 01/05/24.
//

import Firebase
import Foundation
import FirebaseAuth
import AuthenticationServices

class AuthService {
    @Published var userSession: FirebaseAuth.User?
    
    static let shared = AuthService()
    
    init() {
        self.userSession = Auth.auth().currentUser
    }
    
    @MainActor
    func loginWithAppleSignIn(_ credential: OAuthCredential) async throws {
        let result = try await Auth.auth().signIn(with: credential)
        self.userSession = result.user
    }
    
    func signOut() {
        try? Auth.auth().signOut()
        self.userSession = nil
    }
}
