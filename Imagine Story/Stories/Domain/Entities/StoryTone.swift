//
//  StoryTone.swift
//  Imagine Story
//
//  Created by Quentin Kabasele on 23/11/2025.
//

import Foundation
import SwiftUI

struct StoryTone: Identifiable, Codable, Hashable {
    let id: String
    let name: String
    let description: String
    
    // Propriété calculée pour obtenir le nom d'affichage localisé
    var displayName: String {
        switch name.lowercased() {
        case "adventurous":
            return "Aventureux"
        case "calm":
            return "Apaisant"
        case "educational":
            return "Éducatif"
        case "happy":
            return "Joyeux"
        case "magical":
            return "Magique"
        case "playful":
            return "Amusant"
        default:
            return name.capitalized
        }
    }
    
    // Propriété calculée pour la couleur associée à la tonalité
    var color: Color {
        switch name.lowercased() {
        case "adventurous":
            return .orange
        case "calm":
            return .blue
        case "educational":
            return .purple
        case "happy":
            return .yellow
        case "magical":
            return .pink
        case "playful":
            return .green
        default:
            return .gray
        }
    }
    
    // Propriété calculée pour l'icône associée à la tonalité
    var icon: String {
        switch name.lowercased() {
        case "adventurous":
            return "🏔️"
        case "calm":
            return "🌙"
        case "educational":
            return "📚"
        case "happy":
            return "😊"
        case "magical":
            return "✨"
        case "playful":
            return "🎭"
        default:
            return "🎨"
        }
    }
}
