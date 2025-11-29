//
//  StoryThemeMapper.swift
//  Imagine Story
//
//  Created by Quentin Kabasele on 23/11/2025.
//

import Foundation

class StoryThemeMapper {
    static func map(themeDTO: StoryThemeDTO) -> StoryTheme {
        return StoryTheme(
            id: themeDTO.id,
            name: themeDTO.name,
            description: themeDTO.description
        )
    }
    
    static func mapList(themeDTOs: [StoryThemeDTO]) -> [StoryTheme] {
        return themeDTOs.map { map(themeDTO: $0) }
    }
}