//
//  GetAllTonesUseCase.swift
//  Imagine Story
//
//  Created by Quentin Kabasele on 23/11/2025.
//

import Foundation

protocol GetAllTonesUseCaseProtocol {
    func execute() async throws -> [StoryTone]
}

class GetAllTonesUseCase: GetAllTonesUseCaseProtocol {
    private let repository: StoryToneRepositoryProtocol
    
    init(repository: StoryToneRepositoryProtocol = StoryToneRepository()) {
        self.repository = repository
    }
    
    func execute() async throws -> [StoryTone] {
        return try await repository.getAllTones()
    }
}
