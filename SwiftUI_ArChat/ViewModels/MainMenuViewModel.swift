//
//  MainMenuViewModel.swift
//  SwiftUI_ArChat
//
//  Created by Никита Ананьев on 11.04.2022.
//

import SwiftUI

class MainMenuViewModel: ObservableObject, ARDataDelegate {
    
    @Published var text = "Контакты"
    @Published var color = Color.green
    @Published var menu = Menu.contacts
    
    @Published var chatUser: ChatUser?

    @ObservedObject var chatLogViewModel = ChatLogViewModel(chatUser: nil)
    @ObservedObject var contactListViewModel = ContactListTabItemViewModel()
    @ObservedObject var contactMediaViewModel = ContactMediaViewModel()
    var skipCounter = 0
    init() {
        ARData.shared.mainMenuDelegate = self
        ARData.shared.contactsDelegate = contactListViewModel
        ARData.shared.chatDelegate = chatLogViewModel
        ARData.shared.contactMediaDelegate = contactMediaViewModel
        

    }
    @Published var tabIndexSelection = 0 {
        didSet {
            if self.tabIndexSelection == 0 {
                withAnimation {
                    text = "Контакты"
                    color = Color.green
                }
            }
            if self.tabIndexSelection == 1 {
                withAnimation {
                    text = "Чат"
                    color = Color.blue
                }
            }
            if self.tabIndexSelection == 2 {
                withAnimation {
                    text = "Медиа"
                    color = Color.purple
                }
            }
        }
    }

    enum Menu {
        case contacts, chat, media
    }
    func followTo(section: Menu) {
        withAnimation{
            switch section {
            case .contacts:
                text = "Контакты"
                color = Color.green
                tabIndexSelection = 0
                menu = .contacts
            case .chat:
                text = "Чат"
                color = Color.blue
                tabIndexSelection = 1
                self.chatLogViewModel.chatUser = chatUser
                self.chatLogViewModel.fetchMessages()
                menu = .chat
            case .media:
                text = "Медиа"
                color = Color.purple
                tabIndexSelection = 2
                menu = .media
            }
        }
        
    }
    
    func stopSession() {
        selectionStopped()
    }
    
    func zPositionChanged(z: CGFloat) {
    }
    
    var zeroFaceCoords = FaceCoordinates()
    
    func selectionStopped() {
        zeroFaceCoords.resetCoordinates()
        skipCounter = 0
        
    }
    
    
    func xPositionChanged(x: CGFloat) {
        
        skipCounter += 1

        if skipCounter < 20 {
            return
        }
        if ARData.shared.isSessionRunning == false {
            return
        }
        if zeroFaceCoords.x == 0 {
            zeroFaceCoords.x = x
            return
        }
        let moveValueX = x - zeroFaceCoords.x
        print(moveValueX)
        
        
        
        print(index)
        switch moveValueX {
        case -0.21 ... -0.2:
            withAnimation {
                DispatchQueue.main.async {
                    self.zeroFaceCoords.x = 0
                    self.nextView()

                    
                }
            }
        case -0.2...0.2:
            withAnimation {
                DispatchQueue.main.async {
                }
            }
        case 0.2...0.21:
            withAnimation {
                DispatchQueue.main.async {
                    self.zeroFaceCoords.x = 0
                    self.previousView()

                }
            }
        default: withAnimation {
            DispatchQueue.main.async {
                self.zeroFaceCoords.x = 0

            }
        }
        }
    }
    // следующая страница
    private func nextView() {
        if menu == .chat {
            followTo(section: .media)
        } else {
            followTo(section: .chat)
            self.chatLogViewModel.chatUser = chatUser
            self.chatLogViewModel.fetchMessages()
        }
    
    }
    
    // предыдущая страница
    private func previousView() {
        if menu == .media {
            followTo(section: .chat)
        } else {
            followTo(section: .contacts)
        }
    
    }
    func yPositionChanged(y: CGFloat) {
        // получить данные об изменении Позиции по Y
    }

}
