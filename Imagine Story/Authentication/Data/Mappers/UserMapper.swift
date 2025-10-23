//
//  UserMapper.swift
//  Imagine Story
//
//  Created by Quentin Kabasele on 08/10/2025.
//

import Foundation

class UserMapper {
    static func map(from userDTO: UserDTO) -> User {
        return User(
            id: userDTO.user.id,
            firstName: userDTO.user.firstname,
            lastName: userDTO.user.lastname,
            email: userDTO.user.email,
            token: userDTO.token
        )
    }
}
