//
//  ProfileView.swift
//  Imagine Story
//
//  Created by Quentin Kabasele on 08/10/2025.
//

import SwiftUI

struct ProfileView: View {
    let appVersion = "1.0.0"
    var body: some View {
        List {
            Section {
                HStack(spacing: 8) {
                    Text(User.MOCK_USER.initials)
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(width: 72, height: 72)
                        .background(Color.gray.opacity(0.7))
                        .clipShape(Circle())
                    VStack(alignment: .leading, spacing: 4) {
                        Text(User.MOCK_USER.fullName)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        
                        Text(User.MOCK_USER.email)
                            .font(.footnote)
                            .foregroundColor(.gray)
                    }
                }
            }
            
            Section(ProfileViewConstants.generalSectionTitle) {
                HStack {
                    SettingsRowView(imageName: "gear", title: "Version", tintColor: Color(.systemGray))
                    Spacer()
                    Text(appVersion)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            
            Section(ProfileViewConstants.accountSectionTitle) {
                Button {
                    print("Sign out")
                } label: {
                    SettingsRowView(imageName: "arrow.left.circle.fill", title: "Déconnexion", tintColor: .red)
                }
                
                Button {
                    print("Deleting account....")
                } label: {
                    SettingsRowView(imageName: "xmark.circle.fill", title: "Supprimer le compte", tintColor: .red)
                }
            }
        }
    }
}

#Preview {
    ProfileView()
}
