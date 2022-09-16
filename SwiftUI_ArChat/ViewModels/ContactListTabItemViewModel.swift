//
//  ContactListTabItemViewModel.swift
//  SwiftUI_ArChat
//
//  Created by Никита Ананьев on 11.04.2022.
//

import SwiftUI
import Firebase

class ContactListTabItemViewModel: ObservableObject, ARDataDelegate {

    
    @Published var errorMessage = ""
    @Published var chatUser: ChatUser?
    @Published var isUserCurrentlyLoggedOut = false
    @Published var recentMessages = [RecentMessage]()

    init() {
        
        DispatchQueue.main.async {
            self.isUserCurrentlyLoggedOut = FirebaseManager.shared.auth.currentUser?.uid == nil
        }
        
        fetchCurrentUser()
        fetchRecentMessages()
    }
    
    
    private var firestoreListener: ListenerRegistration?
    
    func fetchRecentMessages() {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        
        firestoreListener?.remove()
        self.recentMessages.removeAll()
        
        firestoreListener = FirebaseManager.shared.firestore
            .collection(FirebaseConstants.recentMessages)
            .document(uid)
            .collection(FirebaseConstants.messages)
            .order(by: FirebaseConstants.timestamp)
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    self.errorMessage = "Failed to listen for recent messages: \(error)"
                    print(error)
                    return
                }
                
                querySnapshot?.documentChanges.forEach({ change in
                    let docId = change.document.documentID
                    
                    if let index = self.recentMessages.firstIndex(where: { rm in
                        return rm.id == docId
                    }) {
                        self.recentMessages.remove(at: index)
                    }
                    
                    do {
                        if let rm = try? change.document.data(as: RecentMessage.self) {
                            self.recentMessages.insert(rm, at: 0)
                        }
                    } catch {
                        print(error)
                    }
                })
            }
    }
    
    func fetchCurrentUser() {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            self.errorMessage = "Could not find firebase uid"
            return
        }
        
        FirebaseManager.shared.firestore.collection("users").document(uid).getDocument { snapshot, error in
            if let error = error {
                self.errorMessage = "Failed to fetch current user: \(error)"
                print("Failed to fetch current user:", error)
                return
            }
            
            self.chatUser = try? snapshot?.data(as: ChatUser.self)
            FirebaseManager.shared.currentUser = self.chatUser
        }
    }
    
    
    
    
    // MARK: AR-MODULE
    func stopSession() {
        selectionStopped()
    }
    

    @Published var contactSelectedId: Int = 0
    
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
        case -0.2 ... -0.1:
            withAnimation {
                DispatchQueue.main.async {
                    self.zeroFaceCoords.y = 0
                    self.previousView()
                }
            }
            
        case -0.1...0.1:
            withAnimation {
                DispatchQueue.main.async {
                    
                }
            }
            
        case 0.1...0.2:
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
        if contactSelectedId != recentMessages.count - 1 {
            contactSelectedId = contactSelectedId + 1
        }
    }
    
    // предыдущая страница
    func previousView() {
        if contactSelectedId != 0 {
            contactSelectedId = contactSelectedId - 1
        }
    }
    
    func zPositionChanged(z: CGFloat) {
    }
    
    
}
