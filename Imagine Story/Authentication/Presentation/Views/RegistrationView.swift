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
    @EnvironmentObject var viewModel: AuthViewModel

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
                        InputView(text: $firstName, title: "Prénom", placeholder: "Entrz votre prénom")

                        InputView(text: $lastName, title: "Nom de famille", placeholder: "Entrez votre nom de famille")

                        InputView(text: $email, title: "Adresse email", placeholder: "Entrez votre adresse email")
                        
                        InputView(text: $password, title: "Mot de passe", placeholder: "Entrez votre mot de passe", isSecureField: true)
                        
                        InputView(text: $confirmPassword, title: "Confirmation du mot de passe", placeholder: "Confirmez votre mot de passe", isSecureField: true)
                    }
                    .padding(.top, 12)
                    
                    // Sign up button
                    Button {
                        print("Sign up button pressed")
                        Task {
                            try await viewModel.register(firstname: firstName, lastname: lastName, email: email, password: password, confirmPassword: confirmPassword)
                        }
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
