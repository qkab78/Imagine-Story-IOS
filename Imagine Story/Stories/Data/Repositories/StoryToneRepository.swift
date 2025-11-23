//
//  StoryToneRepository.swift
//  Imagine Story
//
//  Created by Quentin Kabasele on 23/11/2025.
//

import Foundation

protocol StoryToneRepositoryProtocol {
    func getAllTones() async throws -> [StoryTone]
}

class StoryToneRepository: StoryToneRepositoryProtocol {
    private let apiDataSource: StoriesApiDataSource
    
    init(apiDataSource: StoriesApiDataSource = StoriesApiDataSource()) {
        self.apiDataSource = apiDataSource
    }
    
    func getAllTones() async throws -> [StoryTone] {
        let toneDTOs = try await apiDataSource.getAllTones()
        return StoryToneMapper.mapList(toneDTOs: toneDTOs)
    }
}
