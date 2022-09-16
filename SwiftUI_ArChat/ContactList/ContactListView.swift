//
//  ContactListView.swift
//  SwiftUI_ArChat
//
//  Created by Никита Ананьев on 05.04.2022.
//

import SwiftUI
import SDWebImageSwiftUI
import Firebase
import FirebaseFirestoreSwift

struct ContactListView: View {
    
    @ObservedObject var mainMenuViewModel: MainMenuViewModel
    @ObservedObject var contactListViewModel: ContactListTabItemViewModel
    let didSelectNewUser: (ChatUser) -> ()
    
    var body: some View {
        VStack {
            ScrollView {
                ForEachWithIndex(contactListViewModel.recentMessages) { index, recentMessage in
                    ContactView(name: recentMessage.username, image: recentMessage.profileImageUrl, recentMessages: .constant(1), text: recentMessage.text, time: recentMessage.timeAgo)
                        .tag(index)
                        .padding(.leading, contactListViewModel.contactSelectedId == index ? 40 : 5)
                        .animation(.spring(), value: contactListViewModel.contactSelectedId)
                        
                        .onTapGesture {
                            let uid = FirebaseManager.shared.auth.currentUser?.uid == recentMessage.fromId ? recentMessage.toId : recentMessage.fromId
                            let chatUser:ChatUser = .init(id: uid, uid: uid, email: recentMessage.email, profileImageUrl: recentMessage.profileImageUrl, nickname: recentMessage.username)
                            self.didSelectNewUser(chatUser)
                        }
                        .onReceive(contactListViewModel.$contactSelectedId, perform: { _ in
                            let uid = FirebaseManager.shared.auth.currentUser?.uid == recentMessage.fromId ? recentMessage.toId : recentMessage.fromId
                            let chatUser:ChatUser = .init(id: uid, uid: uid, email: recentMessage.email, profileImageUrl: recentMessage.profileImageUrl, nickname: recentMessage.username)
                            self.mainMenuViewModel.chatUser = chatUser
                            self.mainMenuViewModel.chatLogViewModel.chatUser = chatUser
                            
                        })
                }
//                ForEach(viewModel.recentMessages, content: { recentMessage in
//                    ContactView(name: recentMessage.username, image: recentMessage.profileImageUrl, recentMessages: .constant(1), text: recentMessage.text, time: recentMessage.timeAgo)
//                        .onTapGesture {
//                            let uid = FirebaseManager.shared.auth.currentUser?.uid == recentMessage.fromId ? recentMessage.toId : recentMessage.fromId
//                            let chatUser:ChatUser = .init(id: uid, uid: uid, email: recentMessage.email, profileImageUrl: recentMessage.profileImageUrl, nickname: recentMessage.username)
//                            self.didSelectNewUser(chatUser)
//                        }
//                        //.padding(.leading, selectedCell == index ? 30 : 0)
//                })
            }
            
        }
    }
}

struct ContactListView_Previews: PreviewProvider {
    static var previews: some View {
        MainMenuTabView()
    }
}
