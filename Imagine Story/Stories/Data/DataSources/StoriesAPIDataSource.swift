//
//  StoriesApiDataSource.swift
//  Imagine Story
//
//  Created by Quentin Kabasele on 28/09/2025.
//

import Foundation

enum StoriesAPIDataSourceError: Error {
    case invalidURL
    case invalidResponse
    case decodingFailed
    case encodingFailed
    case serverError(String)
}

// MARK: - Create Story Request DTO
struct CreateStoryRequestDTO: Codable {
    let title: String
    let synopsis: String
    let theme: String
    let protagonist: String
    let species: String
    let childAge: Int
    let numberOfChapters: Int
    let language: String
    let tone: String
    let isPrivate: Bool
    let generateCharacters: Bool
    let generateChapterImages: Bool
}

// MARK: - Create Story Response DTO
struct CreateStoryResponseDTO: Codable {
    let id: String
    let title: String
    let synopsis: String
    let slug: String
}

class StoriesApiDataSource {
    
    // MARK: - Create Story
    func createStory(request: CreateStoryRequestDTO, token: String) async throws -> CreateStoryResponseDTO {
        let endpoint = "http://localhost:3333/stories"
        guard let url = URL(string: endpoint) else {
            throw StoriesAPIDataSourceError.invalidURL
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue(token, forHTTPHeaderField: "Authorization")
        
        // Timeout étendu pour la génération d'histoire (5 minutes)
        urlRequest.timeoutInterval = 300
        
        do {
            urlRequest.httpBody = try JSONEncoder().encode(request)
        } catch {
            throw StoriesAPIDataSourceError.encodingFailed
        }
        
        print("🔐 Create Story - Token envoyé: \(token)")
        print("📤 Request body: \(String(data: urlRequest.httpBody ?? Data(), encoding: .utf8) ?? "")")
        print("⏱️ Timeout configuré: \(urlRequest.timeoutInterval) secondes")
        
        // Configuration de session avec timeout étendu
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 300  // 5 minutes pour la requête
        configuration.timeoutIntervalForResource = 600 // 10 minutes pour la ressource complète
        let session = URLSession(configuration: configuration)
        
        let (data, response) = try await session.data(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw StoriesAPIDataSourceError.invalidResponse
        }
        
        print("📥 Response status: \(httpResponse.statusCode)")
        
        guard (200...299).contains(httpResponse.statusCode) else {
            if let errorMessage = String(data: data, encoding: .utf8) {
                print("❌ Server error: \(errorMessage)")
                throw StoriesAPIDataSourceError.serverError(errorMessage)
            }
            throw StoriesAPIDataSourceError.invalidResponse
        }
        
        do {
            let responseDTO = try JSONDecoder().decode(CreateStoryResponseDTO.self, from: data)
            print("✅ Story created successfully with ID: \(responseDTO.id)")
            return responseDTO
        } catch {
            print("❌ Decoding error: \(error)")
            if let jsonString = String(data: data, encoding: .utf8) {
                print("📄 Raw response: \(jsonString)")
            }
            throw StoriesAPIDataSourceError.decodingFailed
        }
    }
    
    func getAllStories() async throws -> [StoryDTO] {
        let endpoint = "http://localhost:3333/stories"
        guard let url = URL(string: endpoint) else {
            throw StoriesAPIDataSourceError.invalidURL
        }

        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw StoriesAPIDataSourceError.invalidResponse
        }
        
        do {
            return try JSONDecoder().decode([StoryDTO].self, from: data)
        } catch {
            throw StoriesAPIDataSourceError.decodingFailed
        }
    }
    
    func getLatestStories() async throws -> [StoryDTO] {
        let endpoint = "http://localhost:3333/stories/all/latest"
        guard let url = URL(string: endpoint) else {
            throw StoriesAPIDataSourceError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw StoriesAPIDataSourceError.invalidResponse
        }
        
        do {
            return try JSONDecoder().decode([StoryDTO].self, from: data)
        } catch {
            throw StoriesAPIDataSourceError.decodingFailed
        }
    }
    
    func getStoryById(id: String) async throws -> StoryDTO {
        let endpoint = "http://localhost:3333/stories/\(id)"
        guard let url = URL(string: endpoint) else {
            throw StoriesAPIDataSourceError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw StoriesAPIDataSourceError.invalidResponse
        }
        
        do {
            return try JSONDecoder().decode(StoryDTO.self, from: data)
        } catch {
            throw StoriesAPIDataSourceError.decodingFailed
        }
    }
    
    func likeStory(id: String) async throws {
        let endpoint = "http://localhost:3333/stories/\(id)/like"
        guard let url = URL(string: endpoint) else {
            throw StoriesAPIDataSourceError.invalidURL
        }
        
        // @todo: Implement like method in the API
        return
    }
    
    func searchSuggestions(payload: String, token: String) async throws -> [StoryDTO] {
        guard let encodedPayload = payload.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            throw StoriesAPIDataSourceError.encodingFailed
        }
        
        let endpoint = "http://localhost:3333/stories/search/suggestions?query=\(encodedPayload)"
        guard let url = URL(string: endpoint) else {
            throw StoriesAPIDataSourceError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.setValue(token, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw StoriesAPIDataSourceError.invalidResponse
        }
        
        do {
            return try JSONDecoder().decode([StoryDTO].self, from: data)
        } catch {
            throw StoriesAPIDataSourceError.decodingFailed
        }
    }
    
    func getAllThemes() async throws -> [StoryThemeDTO] {
        let endpoint = "http://localhost:3333/stories/all/themes"
        guard let url = URL(string: endpoint) else {
            throw StoriesAPIDataSourceError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw StoriesAPIDataSourceError.invalidResponse
        }
        
        do {
            let themes = try JSONDecoder().decode([StoryThemeDTO].self, from: data)
            print("✅ Successfully decoded \(themes.count) themes from API")
            return themes
        } catch {
            print("❌ Decoding error: \(error)")
            if let jsonString = String(data: data, encoding: .utf8) {
                print("📄 Raw response: \(jsonString)")
            }
            throw StoriesAPIDataSourceError.decodingFailed
        }
    }
    
    func getAllTones() async throws -> [StoryToneDTO] {
        let endpoint = "http://localhost:3333/stories/all/tones"
        guard let url = URL(string: endpoint) else {
            throw StoriesAPIDataSourceError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw StoriesAPIDataSourceError.invalidResponse
        }
        
        do {
            let tones = try JSONDecoder().decode([StoryToneDTO].self, from: data)
            print("✅ Successfully decoded \(tones.count) tones from API")
            return tones
        } catch {
            print("❌ Decoding error: \(error)")
            if let jsonString = String(data: data, encoding: .utf8) {
                print("📄 Raw response: \(jsonString)")
            }
            throw StoriesAPIDataSourceError.decodingFailed
        }
    }
    
    func getAllLanguages() async throws -> [StoryLanguageDTO] {
        let endpoint = "http://localhost:3333/stories/all/languages"
        guard let url = URL(string: endpoint) else {
            throw StoriesAPIDataSourceError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw StoriesAPIDataSourceError.invalidResponse
        }
        
        do {
            let languages = try JSONDecoder().decode([StoryLanguageDTO].self, from: data)
            print("✅ Successfully decoded \(languages.count) languages from API")
            return languages
        } catch {
            print("❌ Decoding error: \(error)")
            if let jsonString = String(data: data, encoding: .utf8) {
                print("📄 Raw response: \(jsonString)")
            }
            throw StoriesAPIDataSourceError.decodingFailed
        }
    }
}
