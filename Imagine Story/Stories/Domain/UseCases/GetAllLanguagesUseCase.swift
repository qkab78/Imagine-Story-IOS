//
//  GetAllLanguagesUseCase.swift
//  Imagine Story
//
//  Created by Quentin Kabasele on 23/11/2025.
//

import Foundation

protocol GetAllLanguagesUseCaseProtocol {
    func execute() async throws -> [StoryLanguage]
}

class GetAllLanguagesUseCase: GetAllLanguagesUseCaseProtocol {
    private let repository: StoryLanguageRepositoryProtocol
    
    init(repository: StoryLanguageRepositoryProtocol = StoryLanguageRepository()) {
        self.repository = repository
    }
    
    func execute() async throws -> [StoryLanguage] {
        return try await repository.getAllLanguages()
    }
}
