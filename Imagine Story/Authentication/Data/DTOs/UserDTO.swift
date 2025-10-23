//
//  UserDTO.swift
//  Imagine Story
//
//  Created by Quentin Kabasele on 08/10/2025.
//

import Foundation

struct UserDTO: Codable {
    let token: String
    let user: UserDetailsDTO
}
