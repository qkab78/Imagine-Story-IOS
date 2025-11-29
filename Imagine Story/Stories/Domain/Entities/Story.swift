//
//  Story.swift
//  Imagine Story
//
//  Created by Quentin Kabasele on 28/09/2025.
//

import Foundation

struct Story: Identifiable, Codable {
    let id: String
    let title: String
    let synopsis: String
    let coverImage: String
    let numberOfChapters: Int
    let theme: String
    let themeName: String
    let themeDescription: String
//    let userId: String
//    let slug: String
    let conclusion: String
    let chapters: [StoryChapter]
    let chapterImages: [StoryChapterImage]
    let createdAt: String
    let isLiked: Bool
    let language: StoryLanguage
    let tone: StoryTone
}
