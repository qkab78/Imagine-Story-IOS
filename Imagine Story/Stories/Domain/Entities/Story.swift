//
//  Story.swift
//  Imagine Story
//
//  Created by Quentin Kabasele on 28/09/2025.
//

import Foundation

struct Story: Identifiable, Hashable, Codable {
    let id: String
    let title: String
    let synopsis: String
    let coverImage: String
    let numberOfChapters: Int
    let tone: String
    let theme: String
//    let userId: String
//    let slug: String
//    let conclusion: String
//    let chapters: [StoryChapterDTO]
//    let chapterImages: [StoryChapterImageDTO]
    let createdAt: String
}
