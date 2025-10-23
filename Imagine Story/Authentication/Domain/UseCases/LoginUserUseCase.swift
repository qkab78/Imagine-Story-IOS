//
//  LoginUserUseCase.swift
//  Imagine Story
//
//  Created by Quentin Kabasele on 08/10/2025.
//

import Foundation

class LoginUserUseCase {
    let userRepository = UserRepository()
    
    func execute(email: String, password: String) async throws -> User {
        return try await userRepository.login(email: email, password: password)
    }
}
