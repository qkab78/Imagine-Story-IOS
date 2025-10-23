//
//  AuthViewModel.swift
//  Imagine Story
//
//  Created by Quentin Kabasele on 08/10/2025.
//

import Foundation

@MainActor
class AuthViewModel: ObservableObject {
    @Published var user: User?
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    
    private let loginUserUseCase = LoginUserUseCase()
    private let registerUserUseCase = RegisterUserUseCase()
    private let logoutUserUseCase = LogoutUserUseCase()
    private let authStoreKey = "user"

    init() {
        loadUserFromDefaults()
    }

    func register(
        firstname: String,
        lastname: String,
        email: String,
        password: String,
        confirmPassword: String
    ) async throws {
        if user != nil {
            errorMessage = "Vous êtes déjà connecté."
            return
        }
        if password != confirmPassword {
            errorMessage = "Les mots de passe ne correspondent pas."
            return
        }
        isLoading = true
        errorMessage = nil
        
        do {
            let result = try await registerUserUseCase.execute(firstname: firstname, lastname: lastname, email: email, password: password, confirmPassword: confirmPassword)
            user = result
            saveUserToDefaults()
        }
        catch {
            errorMessage = "Une erreur est survenue lors de la création de compte. Veuillez réessayer ultérieurement."
            print("Une erreur est survenue lors de la création de compte : \(error.localizedDescription)")
        }
        isLoading = false
    }
    func login(email: String, password: String) async throws {
        isLoading = true
        errorMessage = nil
        
        do {
            let result = try await loginUserUseCase.execute(email: email, password: password)
            user = result
            saveUserToDefaults()
        } catch {
            errorMessage = "Une erreur est survenue lors de la connexion. Veuillez réessayer ultérieurement."
            print("Une erreur est survenue lors de la connexion : \(error.localizedDescription)")
        }
        isLoading = false
    }
    
    func logout() async throws -> Void {
        try await logoutUserUseCase.execute()
        user = nil
        UserDefaults.standard.removeObject(forKey: authStoreKey)
    }
    
    private func loadUserFromDefaults() {
        if let data = UserDefaults.standard.data(forKey: authStoreKey) {
            do {
                self.user = try JSONDecoder().decode(User.self, from: data)
            } catch {
                print("Erreur de decoding du user : \(error.localizedDescription)")
            }
        }
    }
    
    private func saveUserToDefaults() {
        if let encodedUser = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(encodedUser, forKey: authStoreKey)
        }
    }
}
