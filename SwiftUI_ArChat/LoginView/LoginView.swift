//
//  LoginView.swift
//  SwiftUI_ArChat
//
//  Created by Никита Ананьев on 30.03.2022.
//

import SwiftUI

struct LoginView: View {
    
    @State private var email = ""
    @State private var password = ""
    @ObservedObject var firebaseManager = FirebaseManager.shared
    @State var isLogin = false
    var body: some View {
        NavigationView {
            VStack {
                WelcomeLogoView()
                HStack {
                    Text("Войти")
                        .bold()
                        .font(.custom("Apple SD Gothic Neo", size: 45))
                    Spacer()
                }
                .padding(.horizontal, 35)
                .padding(.vertical, 15)
                HStack {
                    Image(systemName: "at")
                        .foregroundColor(.gray)
                    TextField("Email ID", text: $email)
                        .overlay(VStack{Divider().offset(x: 0, y: 15)})
                }
                .padding()
                HStack {
                    Image(systemName: "key")
                        .foregroundColor(.gray)
                    HStack{
                        SecureField("Password", text: $password)
                        Image(systemName: "eye.slash")
                            .foregroundColor(.gray)
                    }
                    .overlay(VStack{Divider().offset(x: 0, y: 15)})
                }
                .padding()
                HStack {
                    Spacer()
                    Button(action: { print("Забыли пароль") }){
                        Text("Забыли пароль?")
                            .font(.custom("Apple SD Gothic Neo", size: 15))
                    }
                }.padding()
                
                Button(action: {
                    firebaseManager.signInUser(email: email, password: password)
                }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .frame(width: 280, height: 45)
                            .padding()
                        Text("Продолжить")
                            .font(.custom("Apple SD Gothic Neo", size: 19))
                            .foregroundColor(.white)
                    }
                }
                HStack {
                    Text("Новый пользователь?")
                        .foregroundColor(.gray)
                        .font(.custom("Apple SD Gothic Neo", size: 15))
                    NavigationLink(destination: RegistrationView()) {
                        Text("Регистрация")
                            .font(.custom("Apple SD Gothic Neo", size: 15))
                                    }
                }
            }
            .onReceive(firebaseManager.$didCompleteLogin, perform: { output in
                isLogin = output
            })
            .fullScreenCover(isPresented: $isLogin, onDismiss: nil, content: {
                MainMenuTabView()
            })
            .navigationBarHidden(true)
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

