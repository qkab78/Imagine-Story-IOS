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
}
