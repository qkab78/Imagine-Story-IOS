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

    func login(email: String, password: String) async throws -> User {
        isLoading = true
        errorMessage = nil
        
        do {
            let result = try await loginUserUseCase.execute(email: email, password: password)
            user = result
        } catch {
            errorMessage = "Une erreur est survenue lors de la connexion. Veuillez réessayer ultérieurement."
            print(error.localizedDescription)
        }
        isLoading = false
        
        return user!
    }
}
