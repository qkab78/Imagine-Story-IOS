//
//  LikeStoryUseCase.swift
//  Imagine Story
//
//  Created by Quentin Kabasele on 02/10/2025.
//

import Foundation

class LikeStoryUseCase {
    let repository = StoryRepository()
    
    func execute(id: String) async throws -> Story {
        return try await repository.getStoryById(id: id)
    }
}
