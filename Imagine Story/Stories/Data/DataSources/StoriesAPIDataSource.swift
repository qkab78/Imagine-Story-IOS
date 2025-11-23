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
}

class StoriesApiDataSource {
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
