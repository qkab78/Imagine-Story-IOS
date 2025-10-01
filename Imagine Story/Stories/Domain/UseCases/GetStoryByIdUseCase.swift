//
//  GetStoryByIdUseCase.swift
//  Imagine Story
//
//  Created by Quentin Kabasele on 30/09/2025.
//

import Foundation

class GetStoryByIdUseCase {
    let repository = StoryRepository()
    
    func execute(id: String) async throws -> Story {
        return try await repository.getStoryById(id: id)
    }
}
