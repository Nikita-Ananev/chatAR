//
//  User.swift
//  SwiftUI_ArChat
//
//  Created by Никита Ананьев on 05.04.2022.
//

import FirebaseFirestoreSwift

struct ChatUser: Codable, Identifiable {
    @DocumentID var id: String?
    let uid, email, profileImageUrl, nickname: String
}
