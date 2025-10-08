//
//  RegistrationView.swift
//  Imagine Story
//
//  Created by Quentin Kabasele on 08/10/2025.
//

import SwiftUI

struct RegistrationView: View {
    @State private var email: String = ""
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                VStack(spacing: 24) {
                    // Hero section
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Rejoins l'aventure ! 🚀")
                            .font(.system(size: 32, weight: .bold, design: .default))
                            .foregroundColor(.black)
                        Text("Crée ton compte pour sauvegarder tes histoires magiques !")
                            .foregroundColor(.gray)
                            .font(.headline)
                    }
                        .padding(.vertical, 32)
                    
                    
                    // Form fields
                    VStack(spacing: 24) {
                        InputView(text: $firstName, title: "First Name", placeholder: "Enter your first name")

                        InputView(text: $lastName, title: "Last Name", placeholder: "Enter your last name")

                        InputView(text: $email, title: "Email", placeholder: "Enter your email address")
                        
                        InputView(text: $password, title: "Password", placeholder: "Enter your password", isSecureField: true)
                        
                        InputView(text: $confirmPassword, title: "Confirm Password", placeholder: "Confirm your password", isSecureField: true)
                    }
                    .padding(.top, 12)
                    
                    // Sign up button
                    Button {
                        print("Sign up button pressed")
                    } label: {
                        HStack {
                            Text("Créer un compte")
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
                    // Sign in button
                    Button {
                        dismiss()
                    } label: {
                        HStack(spacing: 3) {
                            Text("Déjà un compte ?")
                            Text("Se connecter")
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
    RegistrationView()
}
