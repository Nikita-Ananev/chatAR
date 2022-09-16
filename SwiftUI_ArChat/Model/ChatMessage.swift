//
//  ChatMessage.swift
//  SwiftUI_ArChat
//
//  Created by Никита Ананьев on 07.04.2022.
//

import Foundation
import FirebaseFirestoreSwift
import UIKit

struct ChatMessage: Codable, Identifiable {
    @DocumentID var id: String?
    let fromId, toId, text: String
    let chatImageUrl: String
    let timestamp: Date
}
