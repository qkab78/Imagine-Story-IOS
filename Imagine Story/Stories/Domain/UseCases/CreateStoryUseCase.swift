//
//  CreateStoryUseCase.swift
//  Imagine Story
//
//  Created by Quentin Kabasele on 23/11/2025.
//

import Foundation

// MARK: - Request Model
struct CreateStoryRequest {
    let title: String
    let synopsis: String
    let theme: String          // theme ID
    let protagonist: String
    let species: String
    let childAge: Int
    let numberOfChapters: Int
    let language: String       // language ID
    let tone: String           // tone ID
    let isPrivate: Bool
    let generateCharacters: Bool
    let generateChapterImages: Bool
}

// MARK: - Response Model
struct CreateStoryResponse {
    let id: String
    let title: String
    let synopsis: String
    let slug: String
}

// MARK: - Protocol
protocol CreateStoryUseCaseProtocol {
    func execute(request: CreateStoryRequest, token: String) async throws -> CreateStoryResponse
}

// MARK: - UseCase Implementation
class CreateStoryUseCase: CreateStoryUseCaseProtocol {
    private let repository: StoryRepository
    
    init(repository: StoryRepository = StoryRepository()) {
        self.repository = repository
    }
    
    func execute(request: CreateStoryRequest, token: String) async throws -> CreateStoryResponse {
        return try await repository.createStory(request: request, token: token)
    }
}

