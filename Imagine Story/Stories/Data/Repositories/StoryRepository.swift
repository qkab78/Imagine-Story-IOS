//
//  StoryRepository.swift
//  Imagine Story
//
//  Created by Quentin Kabasele on 28/09/2025.
//

import Foundation

class StoryRepository {
    let storiesDataSource = StoriesApiDataSource()
    
    func getAllStories() async throws -> [Story] {
        do {
            let storiesData = try await storiesDataSource.getAllStories()
            return storiesData.map(StoryMapper.map)
        } catch {
            fatalError("Error fetching stories: \(error)")
        }
    }
}
