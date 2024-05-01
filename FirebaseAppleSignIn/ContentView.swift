//
//  ContentView.swift
//  FirebaseAppleSignIn
//
//  Created by Edgar Ernesto Vergara Montiel on 01/05/24.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("log_Status") private var logStatus: Bool = false
    
    var body: some View {
        if logStatus {
            HomeView()
        }
        else {
            LoginView()
        }
    }
}

#Preview {
    ContentView()
}
