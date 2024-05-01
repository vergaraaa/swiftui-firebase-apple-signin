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
    @AppStorage("log_Status") private var logStatus: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Text(Auth.auth().currentUser?.displayName ?? "Name")
                
                Button("Log out") {
                    try? Auth.auth().signOut()
                    logStatus = false
                }
                .navigationTitle("Home")
            }
        }
    }
}

#Preview {
    HomeView()
}
