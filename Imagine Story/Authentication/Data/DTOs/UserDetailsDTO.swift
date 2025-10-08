//
//  UserDetailsDTO.swift
//  Imagine Story
//
//  Created by Quentin Kabasele on 08/10/2025.
//

import Foundation

struct UserDetailsDTO: Codable {
    let id: String
    let email: String
    let firstname: String
    let lastname: String
    let fullname: String
    let role: Int
    let avatar: String?
}
