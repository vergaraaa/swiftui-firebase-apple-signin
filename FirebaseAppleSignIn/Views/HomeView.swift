//
//  HomeView.swift
//  FirebaseAppleSignIn
//
//  Created by Edgar Ernesto Vergara Montiel on 01/05/24.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct HomeView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Text(Auth.auth().currentUser?.displayName ?? "Name")
                
                Button("Log out") {
                    AuthService.shared.signOut()
                }
                .navigationTitle("Home")
            }
        }
    }
}

#Preview {
    HomeView()
}
