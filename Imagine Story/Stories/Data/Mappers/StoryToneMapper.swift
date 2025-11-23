//
//  StoryToneMapper.swift
//  Imagine Story
//
//  Created by Quentin Kabasele on 23/11/2025.
//

import Foundation

class StoryToneMapper {
    static func map(toneDTO: StoryToneDTO) -> StoryTone {
        return StoryTone(
            id: toneDTO.id,
            name: toneDTO.name,
            description: toneDTO.description
        )
    }
    
    static func mapList(toneDTOs: [StoryToneDTO]) -> [StoryTone] {
        return toneDTOs.map { map(toneDTO: $0) }
    }
}
