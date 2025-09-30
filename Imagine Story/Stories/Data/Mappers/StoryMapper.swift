//
//  StoryMapper.swift
//  Imagine Story
//
//  Created by Quentin Kabasele on 28/09/2025.
//

import Foundation

class StoryMapper {
    static func map(storyDTO: StoryDTO) -> Story {
        return Story(
            id: storyDTO.id,
            title: storyDTO.title,
            synopsis: storyDTO.synopsis,
            coverImage: "http://localhost:3333/images/covers/\(storyDTO.coverImage)",
            numberOfChapters: storyDTO.numberOfChapters,
//            userId: storyDTO.userId,
//            slug: storyDTO.slug,
//            conclusion: storyDTO.conclusion,
//            chapters: storyDTO.chapters,
//            chapterImages: storyDTO.chapterImages,
            createdAt: storyDTO.createdAt,
        )
    }
}
