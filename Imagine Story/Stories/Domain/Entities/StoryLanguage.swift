//
//  StoryLanguage.swift
//  Imagine Story
//
//  Created by Quentin Kabasele on 23/11/2025.
//

import Foundation

struct StoryLanguage: Identifiable, Codable, Hashable {
    let id: String
    let code: String
    let name: String
    let isFree: Bool
    
    // Propriété calculée pour obtenir le nom d'affichage localisé
    var displayName: String {
        switch code.uppercased() {
        case "FR":
            return "Français"
        case "EN":
            return "English"
        case "ES":
            return "Español"
        case "DE":
            return "Deutsch"
        case "IT":
            return "Italiano"
        case "PT":
            return "Português"
        case "NL":
            return "Nederlands"
        case "PL":
            return "Polski"
        case "RU":
            return "Русский"
        case "AR":
            return "العربية"
        case "JA":
            return "日本語"
        case "TR":
            return "Türkçe"
        case "LI":
            return "Lingála"
        default:
            return name
        }
    }
    
    // Propriété calculée pour le drapeau emoji basé sur le code
    var flag: String {
        switch code.uppercased() {
        case "FR":
            return "🇫🇷"
        case "EN":
            return "🇬🇧"
        case "ES":
            return "🇪🇸"
        case "DE":
            return "🇩🇪"
        case "IT":
            return "🇮🇹"
        case "PT":
            return "🇵🇹"
        case "NL":
            return "🇳🇱"
        case "PL":
            return "🇵🇱"
        case "RU":
            return "🇷🇺"
        case "AR":
            return "🇸🇦"
        case "JA":
            return "🇯🇵"
        case "TR":
            return "🇹🇷"
        case "LI":
            return "🇨🇩"
        default:
            return "🌍"
        }
    }
}
