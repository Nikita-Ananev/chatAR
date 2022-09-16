//
//  SuccesLoginView.swift
//  SwiftUI_ArChat
//
//  Created by Никита Ананьев on 01.04.2022.
//

import SwiftUI
import Combine

struct MainMenuTabView: View {
    @ObservedObject var mainMenuViewModel = MainMenuViewModel()
    
    @ObservedObject var firebaseManager = FirebaseManager.shared
    @Environment(\.presentationMode) var presentationMode
    @State var isViraPress = false
    
    var body: some View {
        ZStack {
            ARDisplayView()
                .opacity(0)
            VStack {
                ZStack {
                    TopMenuView(viewModel: mainMenuViewModel, presentationMode: presentationMode)
                }
                
                Spacer()
            }
            .ignoresSafeArea(.all, edges: .all)
            
            VStack {
                
                TabView(selection: $mainMenuViewModel.tabIndexSelection) {
                    ContactListTabItemView(mainMenuViewModel: mainMenuViewModel, chatLogViewModel: mainMenuViewModel.chatLogViewModel)
                        .tag(0)
                    ChatLogTabItemView(vm: mainMenuViewModel.chatLogViewModel)
                        .tag(1)
                    ContactMediaView(vm: mainMenuViewModel.contactMediaViewModel)
                        .tag(2)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .tabViewStyle(PageTabViewStyle())
                .ignoresSafeArea(.all, edges: .bottom)
                            
                
                
            }
            .padding(.top, 60)
            
            VStack {
                Spacer()
                Button {
                    
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 25)
                            .fill(
                                AngularGradient(gradient: Gradient(colors: [.red, .yellow, .green, .blue, .purple, .red]), center: .center)
                            )
                        VStack(spacing: 0) {
                            Text("VIRA")
                                .font(.custom("Apple SD Gothic Neo", size: 17))
                                .foregroundColor(.white)
                                .bold()
                            Text("Control")
                                .font(.custom("Apple SD Gothic Neo", size:10))
                                .bold()
                                .foregroundColor(.white)
                            
                        }
                        
                        
                    }
                }
                .frame(height: 25)
                .padding(50)
                .padding(.horizontal, 70)
                .padding(.bottom, mainMenuViewModel.tabIndexSelection == 1 ? 55: 0)
                .animation(.easeIn, value: mainMenuViewModel.tabIndexSelection)
                .onLongPressGesture(minimumDuration: 200.0, maximumDistance: .infinity, pressing: { pressing in
                    self.isViraPress = pressing
                    if pressing {
                        // Кнопка VIRA нажата
                        print("КНОПКА НАЖАТА")
                        withAnimation {
                            ARData.shared.restartSession()

                        }

                    } else {
                        // Кнопка VIRA не нажата
                        withAnimation {
                            ARData.shared.stopSession()
                        }
                    }
                }, perform: { })
                
            }
            
            .ignoresSafeArea(.all, edges: .bottom)
            
        }
    }
}

struct ContatsMenuView_Previews: PreviewProvider {
    static var previews: some View {
        MainMenuTabView()
    }
}


