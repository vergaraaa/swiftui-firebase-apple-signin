//
//  ContentView.swift
//  FirebaseAppleSignIn
//
//  Created by Edgar Ernesto Vergara Montiel on 01/05/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = ContentViewModel()
    
    var body: some View {
        if viewModel.userSession != nil {
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
