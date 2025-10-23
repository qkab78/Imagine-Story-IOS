//
//  RegisterUseCase.swift
//  Imagine Story
//
//  Created by Quentin Kabasele on 23/10/2025.
//

import Foundation

class RegisterUserUseCase {
    let userRepository = UserRepository()
    
    func execute(
        firstname: String,
        lastname: String,
        email: String,
        password: String,
        confirmPassword: String
    ) async throws -> User {
        return try await userRepository.register(firstname: firstname, lastname: lastname, email: email, password: password, confirmPassword: confirmPassword)
    }
}
