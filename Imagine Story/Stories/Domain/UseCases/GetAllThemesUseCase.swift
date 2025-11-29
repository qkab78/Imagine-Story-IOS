//
//  GetAllThemesUseCase.swift
//  Imagine Story
//
//  Created by Quentin Kabasele on 23/11/2025.
//

import Foundation

protocol GetAllThemesUseCaseProtocol {
    func execute() async throws -> [StoryTheme]
}

class GetAllThemesUseCase: GetAllThemesUseCaseProtocol {
    private let repository: StoryThemeRepositoryProtocol
    
    init(repository: StoryThemeRepositoryProtocol = StoryThemeRepository()) {
        self.repository = repository
    }
    
    func execute() async throws -> [StoryTheme] {
        return try await repository.getAllThemes()
    }
}