//
//  RegistrationView.swift
//  SwiftUI_ArChat
//
//  Created by Никита Ананьев on 30.03.2022.
//

import SwiftUI

struct RegistrationView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @State private var email = ""
    @State private var password = ""
    @State private var secondPassword = ""
    @State private var nickname = ""
    
    @State private var image: UIImage?
    @State private var showImagePicker = false
    @ObservedObject var firebaseManager = FirebaseManager.shared
        
    
    var body: some View {
        ZStack {
            BackToLoginButtonView(presentationMode: presentationMode)
            VStack {
                RegistrationLogoView()
                    .padding(.top, 55)
                HStack {
                    Image(systemName: "person")
                        .foregroundColor(.gray)
                    TextField("Nickname", text: $nickname)
                        .overlay(VStack{Divider().offset(x: 0, y: 15)})
                    UserPhotoPickerView(image: image)
                        .onTapGesture {
                            showImagePicker.toggle()
                        }
                }
                .padding(.horizontal, 55)
                .padding(.bottom, 10)
                
                VStack(spacing: 25) {
                    HStack {
                        Image(systemName: "at")
                            .foregroundColor(.gray)
                        TextField("Email ID", text: $email)
                            .overlay(VStack{Divider().offset(x: 0, y: 15)})
                    }
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
                    HStack {
                        Image(systemName: "key")
                            .foregroundColor(.gray)
                        HStack{
                            SecureField("Confirm password", text: $password)
                            Image(systemName: "eye.slash")
                                .foregroundColor(.gray)
                        }
                        .overlay(VStack{Divider().offset(x: 0, y: 15)})
                    }
                }
                .padding(.horizontal, 35)
                                
                Button {
                    firebaseManager.createNewAccount(email: email, nickname: nickname, password: password, image: image ?? UIImage(named: "personPhoto")!)
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .frame(width: 280, height: 45)
                            .padding()
                        Text("Продолжить")
                            .font(.custom("Apple SD Gothic Neo", size: 19))
                            .foregroundColor(.white)
                    }
                }
                .padding()

                Spacer()
            }
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(sourceType: .photoLibrary, selectedImage: $image)
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}



struct RegistrationLogoView: View {
    var body: some View {
        VStack {
            Text("Create a new")
                .font(.custom("Apple SD Gothic Neo", size: 45))
                .multilineTextAlignment(.center)
                .foregroundStyle(
                    LinearGradient(
                        colors: [.cyan, .green, .orange, .red, .purple, .blue, .cyan],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
            Text("pinoteca")
                .font(.custom("Apple SD Gothic Neo", size: 25))
                .multilineTextAlignment(.center)
                .foregroundStyle(
                    LinearGradient(
                        colors: [.red, .purple, .blue, .cyan],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
            Text("User")
                .bold()
                .font(.custom("Apple SD Gothic Neo", size: 55))
                .multilineTextAlignment(.center)
                .foregroundStyle(
                    LinearGradient(
                        colors: [.cyan, .green, .orange, .red, .purple, .blue, .cyan],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
        }
    }
}

struct BackToLoginButtonView: View {
    var presentationMode: Binding<PresentationMode>
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Image(systemName: "arrow.uturn.left")
                        Text("Назад")
                    }
                    .padding()
                }
                Spacer()
            }
            Spacer()
        }
    }
}

struct UserPhotoPickerView: View {
    let image: UIImage?
    var body: some View {
        ZStack {
            Image(uiImage: (image ?? UIImage(named: "personPhoto")!))
                .resizable()
                .frame(width: 100, height: 100)
                .cornerRadius(50)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(LinearGradient(
                            colors: [.cyan, .green, .orange, .red, .purple, .blue, .cyan],
                            startPoint: .leading,
                            endPoint: .trailing
                        ), lineWidth: 1)
                )
            
            VStack {
                Text("Выбрать фото")
                    .font(.custom("Apple SD Gothic Neo", size: 15))
                    .padding(.top, 125)
            }
        }
    }
}
