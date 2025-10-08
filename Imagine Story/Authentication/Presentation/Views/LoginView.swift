//
//  LoginView.swift
//  Imagine Story
//
//  Created by Quentin Kabasele on 08/10/2025.
//

import SwiftUI

struct LoginView: View {
    @State var appTitle: String = "Imagine Story"
    @State var email: String = ""
    @State var password: String = ""
    @EnvironmentObject var viewModel: AuthViewModel

    let linearBackgroundColor = LinearGradient(colors: [
        Color(red: 0.89, green: 0.949, blue: 0.992),
        Color(red: 0.941, green: 0.973, blue: 1)
    ], startPoint:  .topLeading, endPoint: .bottomTrailing)

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                VStack(spacing: 24) {
                    // Hero section
                    Text(appTitle)
                        .font(.system(size: 32, weight: .bold, design: .default))
                        .foregroundColor(.black)
                        .padding(.vertical, 32)
                    
                    
                    // Form fields
                    VStack(spacing: 24) {
                        InputView(text: $email, title: "Email", placeholder: "Enter your email address")
                        
                        InputView(text: $password, title: "Password", placeholder: "Enter your password", isSecureField: true)
                    }
                    .padding(.top, 12)
                    
                    // Forgot password
                    NavigationLink {
                        RegistrationView()
                    } label: {
                        HStack(spacing: 3) {
                            Text("Mot de passe oublié ?")
                            Text("🤔")
                                .fontWeight(.bold)
                        }
                        .font(.footnote)
                        .position(x: geometry.size.width * 0.7, y: 0)
                        .frame(height: 8)
                    }
                    // Sign in button
                    Button {
                        Task {
                            try await viewModel.login(email: email, password: password)
                        }
                    } label: {
                        HStack {
                            Text("Se connecter")
                                .fontWeight(.semibold)
                            Image(systemName: "chevron.right")
                        }
                        .foregroundColor(.white)
                        .frame(width: geometry.size.width * 0.9, height: 48)
                    }
                    .background(Color.blue)
                    .cornerRadius(10)
                    .padding(.top, 24)

                    Spacer()
                    // Sign up button
                    NavigationLink {
                        RegistrationView()
                            .navigationBarBackButtonHidden()
                    } label: {
                        HStack(spacing: 3) {
                            Text("Pas de compte ?")
                            Text("S'inscrire")
                                .fontWeight(.bold)
                        }
                        .font(.system(size: 14))
                    }
                }
                .padding()
            }
        }
    }
}

#Preview {
    LoginView()
}
