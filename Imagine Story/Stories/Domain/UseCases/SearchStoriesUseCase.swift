//
//  SearchStoriesUseCase.swift
//  Imagine Story
//
//  Created by Quentin Kabasele on 18/11/2025.
//

import Foundation

class SearchStoriesUseCase {
    private let storyRepository: StoryRepository
    
    init(storyRepository: StoryRepository = StoryRepository()) {
        self.storyRepository = storyRepository
    }
    
    func execute(query: String, userToken: String) async throws -> [Story] {
        guard !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return []
        }
        
        return try await storyRepository.searchStories(query: query, userToken: userToken)
    }
}
