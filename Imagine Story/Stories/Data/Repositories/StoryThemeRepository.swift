//
//  StoryThemeRepository.swift
//  Imagine Story
//
//  Created by Quentin Kabasele on 23/11/2025.
//

import Foundation

protocol StoryThemeRepositoryProtocol {
    func getAllThemes() async throws -> [StoryTheme]
}

class StoryThemeRepository: StoryThemeRepositoryProtocol {
    private let apiDataSource: StoriesApiDataSource
    
    init(apiDataSource: StoriesApiDataSource = StoriesApiDataSource()) {
        self.apiDataSource = apiDataSource
    }
    
    func getAllThemes() async throws -> [StoryTheme] {
        let themeDTOs = try await apiDataSource.getAllThemes()
        return StoryThemeMapper.mapList(themeDTOs: themeDTOs)
    }
}