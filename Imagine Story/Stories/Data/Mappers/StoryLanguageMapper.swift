//
//  StoryLanguageMapper.swift
//  Imagine Story
//
//  Created by Quentin Kabasele on 23/11/2025.
//

import Foundation

class StoryLanguageMapper {
    static func map(languageDTO: StoryLanguageDTO) -> StoryLanguage {
        return StoryLanguage(
            id: languageDTO.id,
            code: languageDTO.code,
            name: languageDTO.name,
            isFree: languageDTO.isFree
        )
    }
    
    static func mapList(languageDTOs: [StoryLanguageDTO]) -> [StoryLanguage] {
        return languageDTOs.map { map(languageDTO: $0) }
    }
}
