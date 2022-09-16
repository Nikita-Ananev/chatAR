//
//  ContactListTabItemView.swift
//  SwiftUI_ArChat
//
//  Created by Никита Ананьев on 11.04.2022.
//
//
import SwiftUI
import Firebase
//

struct ContactListTabItemView: View {
    
    @State var shouldShowNewMessageScreen = false
    @State var shouldNavigateToChatLogView = false
    
    @ObservedObject var mainMenuViewModel: MainMenuViewModel
    @ObservedObject var chatLogViewModel: ChatLogViewModel
    
    
    var body: some View {
        ZStack {
            ContactListView(mainMenuViewModel: mainMenuViewModel, contactListViewModel: mainMenuViewModel.contactListViewModel, didSelectNewUser: { user in
                self.shouldNavigateToChatLogView.toggle()
                
                self.mainMenuViewModel.chatUser = user
                self.chatLogViewModel.chatUser = user
                self.chatLogViewModel.fetchMessages()
                self.mainMenuViewModel.followTo(section: .chat)
            })
            VStack {
                HStack {
                    Spacer()
                    Button {
                        shouldShowNewMessageScreen.toggle()
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .foregroundColor(.green)
                                .frame(width: 60, height: 50, alignment: .center)
                                .shadow(color: .gray, radius: 2.5, x: 2, y: -2)
                            Image(systemName: "plus")
                                .foregroundColor(.white)
                                .font(.system(size: 16, weight: .bold))
                        }
                    }
                    .padding()
                    .fullScreenCover(isPresented: $shouldShowNewMessageScreen) {
                        CreateNewMessageView(didSelectNewUser: { user in
                            print(user.email)
                            self.shouldNavigateToChatLogView.toggle()
                            self.mainMenuViewModel.chatUser = user
                            self.chatLogViewModel.fetchMessages()
                            self.chatLogViewModel.chatUser = user
                            self.mainMenuViewModel.followTo(section: .chat)
                            
                        })
                    }
                }
                Spacer()
                
            }
        }
    }
}

struct ContactListTabItemView_Previews: PreviewProvider {
    static var previews: some View {
        MainMenuTabView()
    }
}
