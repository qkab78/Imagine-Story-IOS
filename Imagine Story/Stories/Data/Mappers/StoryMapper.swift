//
//  StoryMapper.swift
//  Imagine Story
//
//  Created by Quentin Kabasele on 28/09/2025.
//

import Foundation

class StoryMapper {
    static func map(storyDTO: StoryDTO) -> Story {
        var chapters: [StoryChapter] = []
        var chapterImages: [StoryChapterImage] = []

        storyDTO.chapters.forEach { chapter in
            chapters.append(StoryChapter(title: chapter.title, content: chapter.content))
        }
        storyDTO.chapterImages.forEach { image in
            chapterImages.append(StoryChapterImage(chapterIndex: image.chapterIndex, imageUrl: "http://localhost:3333/images/chapters/\(image.imageUrl)"))
        }
        return Story(
            id: storyDTO.id,
            title: storyDTO.title,
            synopsis: storyDTO.synopsis,
            coverImage: "http://localhost:3333/images/covers/\(storyDTO.coverImage)",
            numberOfChapters: storyDTO.numberOfChapters,
            tone: storyDTO.tone,
            theme: storyDTO.theme,
//            userId: storyDTO.userId,
//            slug: storyDTO.slug,
            conclusion: storyDTO.conclusion,
            chapters: chapters,
            chapterImages: chapterImages,
            createdAt: storyDTO.createdAt,
            isLiked: false
        )
    }
}
