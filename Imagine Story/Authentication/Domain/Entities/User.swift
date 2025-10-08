//
//  User.swift
//  Imagine Story
//
//  Created by Quentin Kabasele on 08/10/2025.
//

import Foundation

struct User: Identifiable, Codable {
    let id: String
    let firstName: String
    let lastName: String
    let email: String
    let token: String
    
    var fullName: String {
        "\(firstName) \(lastName)"
    }
    var initials: String {
        let formatter = PersonNameComponentsFormatter()
        
        if let components = formatter.personNameComponents(from: "\(firstName) \(lastName)") {
            formatter.style = .abbreviated
            return formatter.string(from: components)
        }
        
        // @todo: Return a default image maybe ?
        return ""
    }
}

extension User {
    static var MOCK_USER: User {
        .init(
            id: NSUUID().uuidString,
            firstName: "John",
            lastName: "Doe",
            email: "john.doe@gmail.com",
            token: "testToken"
        )
    }
}
