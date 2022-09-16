//
//  ChatLogViewModel.swift
//  SwiftUI_ArChat
//
//  Created by Никита Ананьев on 11.04.2022.
//

import SwiftUI
import Firebase

class ChatLogViewModel: ObservableObject, ARDataDelegate {
    
    @Published var chatText = ""
    @Published var errorMessage = ""
    @Published var chatImage: UIImage?
    var imageUrl = ""
    
    @Published var chatMessages = [ChatMessage]()
    
    @Published var count = 0
    
    
    var chatUser: ChatUser?

    init(chatUser: ChatUser?) {
        self.chatUser = chatUser
        
        fetchMessages()
    }
    
    var firestoreListener: ListenerRegistration?
    
    func fetchMessages() {
        guard let fromId = FirebaseManager.shared.auth.currentUser?.uid else { return }
        guard let toId = chatUser?.uid else { return }
        firestoreListener?.remove()
        chatMessages.removeAll()
        firestoreListener = FirebaseManager.shared.firestore
            .collection(FirebaseConstants.messages)
            .document(fromId)
            .collection(toId)
            .order(by: FirebaseConstants.timestamp)
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    self.errorMessage = "Failed to listen for messages: \(error)"
                    print(error)
                    return
                }
                
                querySnapshot?.documentChanges.forEach({ change in
                    if change.type == .added {
                        do {
                            if let cm = try? change.document.data(as: ChatMessage.self) {
                                self.chatMessages.append(cm)
                                print("Appending chatMessage in ChatLogView: \(Date())")
                            }
                        } catch {
                            print("Failed to decode message: \(error)")
                        }
                    }
                })
                
                DispatchQueue.main.async {
                    self.count += 1
                }
            }
    }
    func persistImageToStorage() {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        let ref = FirebaseManager.shared.storage.reference(withPath: uid)
        guard let imageData = self.chatImage?.jpegData(compressionQuality: 0.5) else { return }
        
        ref.putData(imageData, metadata: nil) { metadata, err in
            if let err = err {
                print("Failed to push image to Storage: \(err)")
                return
            }
            ref.downloadURL { url, err in
                if let err = err {
                    print("Failed to retrieve downloadURL: \(err)")
                    return
                }
                print(url?.absoluteString ?? "")
                
                guard let url = url else { return }
                self.imageUrl = url.absoluteString
                self.handleSend()
                self.chatImage = nil
            }
        }
    }
    func handleSend() {
        print(chatText)
        guard let fromId = FirebaseManager.shared.auth.currentUser?.uid else { return }
        
        guard let toId = chatUser?.uid else { return }
        
        let document = FirebaseManager.shared.firestore.collection(FirebaseConstants.messages)
            .document(fromId)
            .collection(toId)
            .document()
        
        let msg = ChatMessage(id: nil, fromId: fromId, toId: toId, text: chatText, chatImageUrl: imageUrl, timestamp: Date())
        
        try? document.setData(from: msg) { error in
            if let error = error {
                print(error)
                self.errorMessage = "Failed to save message into Firestore: \(error)"
                return
            }
            
            print("Successfully saved current user sending message")
            
            self.persistRecentMessage()
            
            self.chatText = ""
            self.count += 1
        }
        
        let recipientMessageDocument = FirebaseManager.shared.firestore.collection("messages")
            .document(toId)
            .collection(fromId)
            .document()
        
        try? recipientMessageDocument.setData(from: msg) { error in
            if let error = error {
                print(error)
                self.errorMessage = "Failed to save message into Firestore: \(error)"
                return
            }
            
            print("Recipient saved message as well")
        }
        
    }
    
    private func persistRecentMessage() {
        guard let chatUser = chatUser else { return }
        
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        guard let toId = self.chatUser?.uid else { return }
        
        let document = FirebaseManager.shared.firestore
            .collection(FirebaseConstants.recentMessages)
            .document(uid)
            .collection(FirebaseConstants.messages)
            .document(toId)
        
        let data = [
            FirebaseConstants.timestamp: Timestamp(),
            FirebaseConstants.text: self.chatText,
            FirebaseConstants.fromId: uid,
            FirebaseConstants.toId: toId,
            FirebaseConstants.nickname: chatUser.nickname,
            FirebaseConstants.profileImageUrl: chatUser.profileImageUrl,
            FirebaseConstants.email: chatUser.email
        ] as [String : Any]
        
        // you'll need to save another very similar dictionary for the recipient of this message...how?
        
        document.setData(data) { error in
            if let error = error {
                self.errorMessage = "Failed to save recent message: \(error)"
                print("Failed to save recent message: \(error)")
                return
            }
        }
        
        guard let currentUser = FirebaseManager.shared.currentUser else { return }
        let recipientRecentMessageDictionary = [
            FirebaseConstants.timestamp: Timestamp(),
            FirebaseConstants.text: self.chatText,
            FirebaseConstants.fromId: uid,
            FirebaseConstants.toId: toId,
            FirebaseConstants.nickname: chatUser.nickname,
            FirebaseConstants.profileImageUrl: currentUser.profileImageUrl,
            FirebaseConstants.email: currentUser.email
        ] as [String : Any]
        
        FirebaseManager.shared.firestore
            .collection(FirebaseConstants.recentMessages)
            .document(toId)
            .collection(FirebaseConstants.messages)
            .document(currentUser.uid)
            .setData(recipientRecentMessageDictionary) { error in
                if let error = error {
                    print("Failed to save recipient recent message: \(error)")
                    return
                }
            }
    }
    
    func stopSession() {
        selectionStopped()
    }
    

    @Published var messageSelectedId: Int = 0
    
    func xPositionChanged(x: CGFloat) {
    }
    
    var zeroFaceCoords = FaceCoordinates()
    
    func selectionStopped() {
         zeroFaceCoords.resetCoordinates()
        
    }
    
    func yPositionChanged(y: CGFloat) {
        if ARData.shared.isSessionRunning == false {
            return
        }
        if zeroFaceCoords.y == 0 {
            zeroFaceCoords.y = y
        }
        
        let moveValueY = y - zeroFaceCoords.y
        
        switch moveValueY {
        case -0.1 ... -0.05:
            withAnimation {
                DispatchQueue.main.async {
                    self.zeroFaceCoords.y = 0
                    self.previousView()
                }
            }
            
        case -0.05...0.05:
            withAnimation {
                DispatchQueue.main.async {
                }
            }
            
        case 0.05...0.1:
            withAnimation {
                DispatchQueue.main.async {
                    self.zeroFaceCoords.y = 0
                    self.nextView()

                }
                
            }
            
        default:
            print("nothing")
        }
    }
    func nextView() {
        if messageSelectedId != chatMessages.count - 1 {
            messageSelectedId = messageSelectedId + 1
        }
    }
    
    // предыдущая страница
    func previousView() {
        if messageSelectedId != 0 {
            messageSelectedId = messageSelectedId - 1
        }
    }
    
    func zPositionChanged(z: CGFloat) {
    }
}
