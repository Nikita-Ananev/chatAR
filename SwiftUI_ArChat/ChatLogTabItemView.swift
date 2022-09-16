//
//  ChatLogView.swift
//  SwiftUI_ArChat
//
//  Created by Никита Ананьев on 07.04.2022.
//

import SwiftUI
import Firebase
import SDWebImageSwiftUI

struct DismissingKeyboard: ViewModifier {
    func body(content: Content) -> some View {
        content
            .onTapGesture {
                let keyWindow = UIApplication.shared.connectedScenes
                        .filter({$0.activationState == .foregroundActive})
                        .map({$0 as? UIWindowScene})
                        .compactMap({$0})
                        .first?.windows
                        .filter({$0.isKeyWindow}).first
                keyWindow?.endEditing(true)
        }
    }
}



struct ChatLogTabItemView: View {
    @ObservedObject var vm: ChatLogViewModel
    @ObservedObject var keyboardResponder = KeyboardResponder()
    @State private var showImagePicker = false


    var body: some View {
        ZStack {
            messagesView
            Text(vm.errorMessage)
        }
        .navigationTitle(vm.chatUser?.email ?? "")
        .navigationBarTitleDisplayMode(.inline)
        .onDisappear {
            vm.firestoreListener?.remove()
        }
    }
    
    static let emptyScrollToString = "Empty"
    
    private var messagesView: some View {
        VStack {
            ScrollViewReader { scrollViewProxy in
                ScrollView {
                    VStack {
                        ForEachWithIndex(vm.chatMessages) { index, message in
                            MessageView(message: message)
                                .id(index)
                                .padding(withAnimation(.spring()) { index == vm.messageSelectedId ? 15 : 0 })
                                .animation(.spring(), value: vm.messageSelectedId)
                                
                            
                        }
                        HStack{ Spacer() }
                        
                    }
                    .onReceive(vm.$count) {  _ in
                        withAnimation(.easeOut(duration: 0.5)) {
                            scrollViewProxy.scrollTo(vm.chatMessages.count - 1, anchor: .bottom)
                            vm.messageSelectedId = vm.count - 1
                        }
                    }
                    .onReceive(vm.$messageSelectedId, perform: { _ in
                        withAnimation(.easeOut(duration: 0.5)) {
                            scrollViewProxy.scrollTo(vm.messageSelectedId, anchor: .bottom)
                        }
                    })
                }
                .modifier(DismissingKeyboard())
            }
            .background(Color(.init(white: 0.95, alpha: 1)))
            .safeAreaInset(edge: .bottom) {
                chatBottomBar
                    .ignoresSafeArea(.all, edges: .bottom)
                    .background(Color(.systemBackground).ignoresSafeArea())
                    .padding(.bottom, keyboardResponder.currentHeight)
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(sourceType: .photoLibrary, selectedImage: $vm.chatImage)
            }
            
        }
    }
    
    private var chatBottomBar: some View {
        HStack(spacing: 16) {
            if vm.chatImage == nil {
                Image(systemName: "photo.on.rectangle")
                    .font(.system(size: 24))
                    .foregroundColor(Color(.darkGray))
                    .onTapGesture {
                        showImagePicker.toggle()
                    }
            } else {
                Image(uiImage: vm.chatImage!)
                    .resizable()
                    .frame(width: 50, height: 50)
                    .scaledToFit()
                    .cornerRadius(5)
                    .onTapGesture {
                        showImagePicker.toggle()
                    }
            }
            ZStack {
                DescriptionPlaceholder()
                TextEditor(text: $vm.chatText)
                    .opacity(vm.chatText.isEmpty ? 0.5 : 1)
            }
            
            .frame(height: 40)
            
            Button {
                if vm.chatImage != nil {
                    vm.persistImageToStorage()
                    
                } else {
                    vm.handleSend()
                }
            } label: {
                Text("Send")
                    .foregroundColor(.white)
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background(Color.blue)
            .cornerRadius(4)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
}

struct MessageView: View {
    
    let message: ChatMessage
    
    var body: some View {
        VStack {
            if message.fromId == FirebaseManager.shared.auth.currentUser?.uid {
                HStack {
                    Spacer()
                    VStack {
                        if message.chatImageUrl.count != 0 {
                            WebImage(url: URL(string: message.chatImageUrl))
                                .resizable()
                                .frame(width: 200, height: 200)
                                .scaledToFit()
                        }
                        Text(message.text)
                            .foregroundColor(.white)
                            .padding(10)
                    }
                    .padding(2)
                    .background(Color.blue)
                    .cornerRadius(8)
                }
            } else {
                HStack {
                    VStack {
                        if message.chatImageUrl.count != 0 {
                            WebImage(url: URL(string: message.chatImageUrl))
                                .resizable()
                                .frame(width: 200, height: 200)
                                .scaledToFit()

                        }
                        Text(message.text)
                            .foregroundColor(.black)
                            .padding(10)
                    }
                    .padding(2)
                    .background(Color.white)
                    .cornerRadius(8)
                    Spacer()
                }
            }
        }
        .padding(.horizontal)
        .padding(.top, 8)
    }
}

private struct DescriptionPlaceholder: View {
    var body: some View {
        HStack {
            Text("Description")
                .foregroundColor(Color(.gray))
                .font(.system(size: 17))
                .padding(.leading, 5)
                .padding(.top, -4)
            Spacer()
        }
    }
}


struct ChatLogView_Previews: PreviewProvider {
    static var previews: some View {
        //NavigationView {
        //            ChatLogView(chatUser: .init(data: ["uid": "R8ZrxIT4uRZMVZeWwWeQWPI5zUE3", "email": "waterfall1@gmail.com"]))
        //        }
        MainMenuTabView()
        
    }
}
