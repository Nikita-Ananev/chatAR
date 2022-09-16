//
//  FirebaseManager.swift
//  SwiftUI_ArChat
//
//  Created by Никита Ананьев on 01.04.2022.
//

import Foundation
import Firebase
import FirebaseFirestore
import UIKit
import SwiftUI

class FirebaseManager: NSObject, ObservableObject {
    
    let auth: Auth
    let storage: Storage
    let firestore: Firestore
    
    var currentUser: ChatUser?

    
    @Published var didCompleteLogin = false
        
    static let shared = FirebaseManager()
    
    override init() {
        FirebaseApp.configure()
        
        self.auth = Auth.auth()
        self.storage = Storage.storage()
        self.firestore = Firestore.firestore()
        if auth.currentUser != nil {
            self.didCompleteLogin = true
        }
        super.init()
    }
    
    
    func signInUser(email: String, password: String) {
                
        auth.signIn(withEmail: email, password: password) { authResult, error in
            
            guard error == nil else {
                self.didCompleteLogin = true
                    // error massage
                    // signInErrorMessage = error!.localizedDescription
                return
            }
            switch authResult {
            case .none:
                print("Could not sign in user.")
                self.didCompleteLogin = false
            case .some(_):
                print("User signed in")
                self.didCompleteLogin = true
            }
            
        }
    }
    func logoutUser() {
        do { try auth.signOut() }
        catch { print("already logged out")
        }

    }
    
    func createNewAccount(email: String, nickname: String, password: String, image: UIImage) {
        
        FirebaseManager.shared.auth.createUser(withEmail: email, password: password) { result, err in
            if let err = err {
                print("Failed to create user:", err)
                return
            }
            
            print("Successfully created user: \(result?.user.uid ?? "")")
            
            self.persistImageToStorage(email: email, nickname: nickname, password: password, image: image)
        }
    }
    func persistImageToStorage(email: String, nickname: String, password: String, image: UIImage) {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        let ref = FirebaseManager.shared.storage.reference(withPath: uid)
        guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }
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
                self.storeUserInformation(imageProfileUrl: url, email: email, nickname: nickname, password: password, image: image)
            }
        }
    }
    private func storeUserInformation(imageProfileUrl: URL, email: String, nickname: String, password: String, image: UIImage) {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        let userData = [FirebaseConstants.email: email, FirebaseConstants.uid: uid, FirebaseConstants.profileImageUrl: imageProfileUrl.absoluteString, FirebaseConstants.nickname: nickname]
        FirebaseManager.shared.firestore.collection(FirebaseConstants.users)
            .document(uid).setData(userData) { err in
                if let err = err {
                    print(err)
                    return
                }
                print("Success")
                self.didCompleteLogin = true
            }
    }
    
    
}
