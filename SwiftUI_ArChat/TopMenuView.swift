//
//  TopContactsView.swift
//  SwiftUI_ArChat
//
//  Created by Никита Ананьев on 04.04.2022.
//

import SwiftUI

struct TopMenuView: View {
    @ObservedObject var viewModel: MainMenuViewModel
    @Binding var presentationMode : PresentationMode

    var body: some View {
        
        GeometryReader { geometry in
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .shadow(color: .gray, radius: 3, x: 0, y: 0)
                    .foregroundColor(viewModel.color)
                VStack {
                    Spacer()
                    HStack {
                        Text(viewModel.text)
                            .foregroundColor(.white)
                            .font(.custom("Apple SD Gothic Neo", size: 35))
                            .transition(.move(edge: .leading))
                        Spacer()
                        Button {
                            print("")
                            FirebaseManager.shared.logoutUser()
                            presentationMode.dismiss()
                        } label: {
                            Image(systemName: "slider.horizontal.3")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .foregroundColor(.white)
                        }
                            
                    }
                }
                .padding(.horizontal, 15)
                .padding(.bottom, 10)
                
            }
            .frame(height: 100)

            
        }
        
    }
}


struct TopMenu_Previews: PreviewProvider {
    static var previews: some View {
        Text("asdasd")
        //TopMenuView(viewModel: TopMenuViewModel(), presentationMode: .constant(.))
    }
}


