//
//  InputView.swift
//  Imagine Story
//
//  Created by Quentin Kabasele on 08/10/2025.
//

import SwiftUI

struct InputView: View {
    @Binding var text: String
    let title: String
    let placeholder: String
    var isSecureField: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .foregroundColor(Color(.darkGray))
                .fontWeight(.semibold)
                .font(.footnote)
            
            if isSecureField {
                SecureField(placeholder, text: $text)
                    .font(.system(size: 14))
            } else {
                TextField(placeholder, text: $text)
                    .font(.system(size: 14))
                    .autocorrectionDisabled(true)
                    
            }
            
            Divider()
        }
    }
}

#Preview {
    InputView(text: .constant(""), title: "Adresse email", placeholder: "name@example.com")
}
