//
//  GetLatestStoriesUseCase.swift
//  Imagine Story
//
//  Created by Quentin Kabasele on 30/09/2025.
//

import Foundation

class GetLatestStoriesUseCase {
    let repository = StoryRepository()
    
    func execute() async throws -> [Story] {
        return try await repository.getLatestStories()
    }
}
