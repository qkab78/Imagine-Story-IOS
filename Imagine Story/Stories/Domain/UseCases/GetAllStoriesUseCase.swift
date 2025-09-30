//
//  GetAllStoriesUseCase.swift
//  Imagine Story
//
//  Created by Quentin Kabasele on 28/09/2025.
//

import Foundation

class GetAllStoriesUseCase {
    let repository = StoryRepository()
    
    func execute() async throws -> [Story] {
        return try await repository.getAllStories()
    }
}
