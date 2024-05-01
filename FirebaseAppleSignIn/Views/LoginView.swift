//
//  LoginView.swift
//  FirebaseAppleSignIn
//
//  Created by Edgar Ernesto Vergara Montiel on 01/05/24.
//

import SwiftUI
import Firebase
import CryptoKit
import AuthenticationServices

struct LoginView: View {

    @StateObject private var viewModel = LoginViewModel()
    
    @Environment(\.colorScheme) private var theme
    
    var body: some View {
        ZStack(alignment: .bottom) {
            GeometryReader {
                let size = $0.size
                
                Image(.bg)
                    .resizable()
                    .scaledToFill()
                    .offset(y: -60)
                    .frame(width: size.width, height: size.height)
            }
            .mask {
                Rectangle()
                    .fill(.linearGradient(colors: [
                        .white,
                        .white,
                        .white,
                        .white,
                        .white.opacity(0.9),
                        .white.opacity(0.6),
                        .white.opacity(0.2),
                        .clear,
                        .clear,
                    ], startPoint: .top, endPoint: .bottom))
            }
            .ignoresSafeArea()
            
            VStack(alignment: .leading) {
                Text("Sign in to start your \nlearning experience")
                    .font(.title)
                    .bold()
                
                SignInWithAppleButton(.signIn) { request in
                    let nonce = randomNonceString()
                    viewModel.nonce = nonce
                    
                    request.requestedScopes = [.email, .fullName]
                    request.nonce = sha256(nonce)
                } onCompletion: { result in
                    switch result {
                    case .success(let authorization):
                        Task {
                            try await viewModel.login(authorization)
                        }
                        
                    case .failure(let error):
                        viewModel.showError(error.localizedDescription)
                    }
                }
                .overlay {
                    ZStack {
                        Capsule()
                        
                        HStack {
                            Image(systemName: "applelogo")
                            
                            Text("Sign in with Apple")
                        }
                        .foregroundStyle(theme == .dark ? .black : .white)
                    }
                    .allowsHitTesting(false)
                }
                .frame(height: 45)
                .clipShape(.capsule)
                .padding(.top, 10)
                
                // other sign in options
                Button(action: {}, label: {
                    Text("Other Sign In Options")
                        .foregroundStyle(Color.primary)
                        .frame(height: 40)
                        .frame(maxWidth: .infinity)
                        .contentShape(.capsule)
                        .background {
                            Capsule()
                                .stroke(Color.primary, lineWidth: 0.5)
                        }
                })
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(20)
        }
        .alert(viewModel.errorMessage, isPresented: $viewModel.showAlert) { }
        .overlay {
            if viewModel.isLoading {
                LoadingView()
            }
        }
    }
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        var randomBytes = [UInt8](repeating: 0, count: length)
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
        if errorCode != errSecSuccess {
            fatalError(
                "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
            )
        }
        
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        
        let nonce = randomBytes.map { byte in
            // Pick a random character from the set, wrapping around if needed.
            charset[Int(byte) % charset.count]
        }
        
        return String(nonce)
    }
    
    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
}

#Preview {
    LoginView()
}
