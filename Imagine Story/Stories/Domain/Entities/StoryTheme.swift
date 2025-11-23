//
//  StoryTheme.swift
//  Imagine Story
//
//  Created by Quentin Kabasele on 23/11/2025.
//

import Foundation

struct StoryTheme: Identifiable, Codable, Hashable {
    let id: String
    let name: String
    let description: String
    
    // Propriété calculée pour l'icône basée sur le nom
    var icon: String {
        switch name.lowercased() {
        case let n where n.contains("amitié"):
            return "🤝"
        case let n where n.contains("animaux") || n.contains("nature"):
            return "🐻"
        case let n where n.contains("apprentissage") || n.contains("école"):
            return "📚"
        case let n where n.contains("aventure") || n.contains("exploration"):
            return "🗺️"
        case let n where n.contains("courage") || n.contains("dépassement"):
            return "💪"
        case let n where n.contains("famille") || n.contains("foyer"):
            return "🏠"
        case let n where n.contains("magie") || n.contains("fantastique"):
            return "✨"
        case let n where n.contains("mystère") || n.contains("enquête"):
            return "🔍"
        default:
            return "📖" // Icône par défaut
        }
    }
}