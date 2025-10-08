//
//  USerAPIDataSource.swift
//  Imagine Story
//
//  Created by Quentin Kabasele on 08/10/2025.
//

import Foundation

enum UserAPIDataSourceError: Error {
    case invalidURL
    case invalidResponse
    case decodingFailed
    case encodingFailed
}

struct LoginPayloadDTO: Codable {
    let email: String
    let password: String
}

class UserAPIDataSource {
    func login(email: String, password: String) async throws -> UserDTO {
        let endpoint = "http://localhost:3333/auth/login"
        
        guard let url = URL(string: endpoint) else {
            throw UserAPIDataSourceError.invalidURL
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let payload = LoginPayloadDTO(email: email, password: password)
        guard let encodeData = try? JSONEncoder().encode(payload) else {
            print("encoding failed")
            throw UserAPIDataSourceError.encodingFailed
        }
        
        let (data, response) = try await URLSession.shared.upload(for: urlRequest, from: encodeData)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw UserAPIDataSourceError.invalidResponse
        }
        
        do {
            let user = try JSONDecoder().decode(UserDTO.self, from: data)
            return user
        } catch {
            throw UserAPIDataSourceError.decodingFailed
        }
    }
}
