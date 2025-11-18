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
            print(result)
            user = result
            saveUserToDefaults()
        } catch {
            errorMessage = "Une erreur est survenue lors de la connexion. Veuillez réessayer ultérieurement."
            print("Une erreur est survenue lors de la connexion : \(error.localizedDescription)")
        }
        isLoading = false
    }
    
    func logout() async throws -> Void {
        // Vérification et extraction sécurisée du token
        guard let currentUser = user else {
            errorMessage = "Vous n'êtes pas connecté."
            print("❌ Tentative de logout sans utilisateur connecté")
            return
        }
        
        let token = currentUser.token
        print("🔐 Début du logout pour l'utilisateur: \(currentUser.email)")
        
        do {
            // Appel de l'API de logout
            try await logoutUserUseCase.execute(token: token)
            print("✅ Logout API successful")
            
            // Nettoyage local seulement après succès de l'API
            user = nil
            UserDefaults.standard.removeObject(forKey: authStoreKey)
            errorMessage = nil
            
            print("✅ Logout complet réussi")
        } catch {
            // En cas d'erreur de l'API, on peut quand même nettoyer localement
            print("❌ Erreur lors du logout API: \(error.localizedDescription)")
            errorMessage = "Erreur lors de la déconnexion: \(error.localizedDescription)"
            
            // Optionnel : nettoyer localement même si l'API échoue
            // user = nil
            // UserDefaults.standard.removeObject(forKey: authStoreKey)
            
            throw error
        }
    }
    
    private func loadUserFromDefaults() {
        if let data = UserDefaults.standard.data(forKey: authStoreKey) {
            print(data)
            do {
                self.user = try JSONDecoder().decode(User.self, from: data)
            } catch {
                print("Erreur de décodage du user : \(error.localizedDescription)")
            }
        }
    }
    
    private func saveUserToDefaults() {
        if let encodedUser = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(encodedUser, forKey: authStoreKey)
        }
    }
}
