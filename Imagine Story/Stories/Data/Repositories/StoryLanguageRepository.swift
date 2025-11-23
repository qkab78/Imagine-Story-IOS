//
//  StoryLanguageRepository.swift
//  Imagine Story
//
//  Created by Quentin Kabasele on 23/11/2025.
//

import Foundation

protocol StoryLanguageRepositoryProtocol {
    func getAllLanguages() async throws -> [StoryLanguage]
}

class StoryLanguageRepository: StoryLanguageRepositoryProtocol {
    private let apiDataSource: StoriesApiDataSource
    
    init(apiDataSource: StoriesApiDataSource = StoriesApiDataSource()) {
        self.apiDataSource = apiDataSource
    }
    
    func getAllLanguages() async throws -> [StoryLanguage] {
        let languageDTOs = try await apiDataSource.getAllLanguages()
        return StoryLanguageMapper.mapList(languageDTOs: languageDTOs)
    }
}
