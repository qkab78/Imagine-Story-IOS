//
//  LogoutUserUseCase.swift
//  Imagine Story
//
//  Created by Quentin Kabasele on 23/10/2025.
//

import Foundation

class LogoutUserUseCase {
    let userRepository = UserRepository()
    
    func execute() async throws -> Void {
        return try await userRepository.logout()
    }
}
