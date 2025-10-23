//
//  UserRepository.swift
//  Imagine Story
//
//  Created by Quentin Kabasele on 08/10/2025.
//

import Foundation

class UserRepository {
    let userDataSource = UserAPIDataSource()
    
    func register(
        firstname: String,
        lastname: String,
        email: String,
        password: String,
        confirmPassword: String
    ) async throws -> User {
        do {
            let user = try await userDataSource.register(
                firstname: firstname,
                lastname: lastname,
                email: email,
                password: password,
                confirmPassword: confirmPassword
            )
            return UserMapper.map(from: user)
        } catch {
            print(error.localizedDescription)
            print(error)
            fatalError("Une erreur est survenue lors de la tentative d'enregistrement")
        }
    }

    func login(email: String, password: String) async throws -> User {
        do {
            let user = try await userDataSource.login(email: email, password: password)
            return UserMapper.map(from: user)
        } catch {
            print(error.localizedDescription)
            print(error)
            fatalError("Une erreur est survenue lors de la tentative de connexion")
        }
    }
    
    func logout() {}
}
