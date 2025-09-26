//
//  StoriesService.swift
//  Imagine Story
//
//  Created by Quentin Kabasele on 23/09/2025.
//

import Foundation

class StoriesService {
    func getStories() async throws -> [Story] {
        let endpoint = "https://ced8e849ee03.ngrok-free.app/stories"
        guard let url = URL(string: endpoint) else {
            throw StoryError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from:url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw StoryError.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            return try decoder.decode([Story].self, from: data)
        } catch {
            throw StoryError.invalidData
        }
    }
    
    enum StoryError: Error {
        case invalidResponse
        case invalidData
        case invalidURL
    }
}

