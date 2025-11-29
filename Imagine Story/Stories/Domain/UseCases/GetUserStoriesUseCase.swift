//
//  GetUserStoriesUseCase.swift
//  Imagine Story
//
//  Created by Quentin Kabasele on 29/11/2025.
//

import Foundation

class GetUserStoriesUseCase {
    let repository = StoryRepository()
    
    func execute(token: String) async throws -> [Story] {
        return try await repository.getUserStories(token: token)
    }
}

