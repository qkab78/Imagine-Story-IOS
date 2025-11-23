//
//  StoryLanguageDTO.swift
//  Imagine Story
//
//  Created by Quentin Kabasele on 23/11/2025.
//

import Foundation

struct StoryLanguageDTO: Identifiable, Codable {
    let id: String
    let code: String
    let name: String
    let isFree: Bool
}
