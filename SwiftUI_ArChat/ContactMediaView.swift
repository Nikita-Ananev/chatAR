//
//  ContactMediaView.swift
//  SwiftUI_ArChat
//
//  Created by Никита Ананьев on 27.04.2022.
//

import SwiftUI

struct ContactMediaView: View {
    @ObservedObject var vm: ContactMediaViewModel

    @State var isScrollActive = false
    @State var isShowPhoto = true
    @State var name = "Никита Ананьев"
    @State var time = "Заходил сегодня в 11:29"
    @State var x = 100
    @State var y = 200
    
    var body: some View {
        VStack {
            if !isShowPhoto {
                VStack {
                    ZStack {
                        Image("personPhoto")
                            .resizable()
                            .scaledToFill()
                            .cornerRadius(isScrollActive ? 0 : 50)
                            .onTapGesture {
                                isScrollActive.toggle()
                            }
                        if isScrollActive {
                            VStack {
                                Spacer()
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(name)
                                            .font(.custom("Apple SD Gothic Neo", size: 30))
                                            .foregroundColor(.white)
                                            .bold()
                                        Text(time)
                                            .font(.custom("Apple SD Gothic Neo", size: 15))
                                            .foregroundColor(.white)
                                            .bold()
                                    }
                                    .background(Color.black
                                                    .opacity(0.2)
                                                    .cornerRadius(5))
                                    .padding()

                                    Spacer()
                                }
                                
                            }
                        }
                    }
                    .animation(.spring(), value: isScrollActive)

                    .frame(width: isScrollActive ? 400 : 100, height: isScrollActive ? 400 : 100)
                    .ignoresSafeArea(.container, edges: .top)
                    .padding(isScrollActive ? 0 : 20)
                    if !isScrollActive {
                        
                        VStack {
                            Text(name)
                                .font(.custom("Apple SD Gothic Neo", size: 25))
                                .bold()
                            Text(time)
                                .foregroundColor(.gray)
                        }
                    }
                }
                .animation(.easeOut(duration: 2), value: isShowPhoto)
            }
            ZStack {
                RoundedRectangle(cornerRadius: 5)
                    .foregroundColor(.white)
                    .padding(.top, 30)
                MediaCollectionView(isScrollActive: $isScrollActive, isShowPhoto: $isShowPhoto, vm: vm)
   
            }
            .ignoresSafeArea(.container, edges: .bottom)

            
        }
    }
    struct MediaCollectionView: View {
        @Binding var isScrollActive: Bool
        @Binding var isShowPhoto: Bool
        @ObservedObject var vm: ContactMediaViewModel

        let columns = [
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible())
        ]
        var body: some View {
            GeometryReader { geometry in
                ScrollViewReader { scrollViewProxy in
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 0) {
                            ForEachWithIndex(0...vm.imagesCount, id: \.self) { index,_  in
                                Image("personPhoto")
                                    .resizable()
                                    .frame(width: geometry.size.width / 3, height: geometry.size.width / 3)
                                    .id(index)
                                    
                            }
                            
                        }
                    }
                    .onReceive(vm.$rowSelectedId, perform: { _ in
                        withAnimation(.spring()) {
                            scrollViewProxy.scrollTo(vm.rowSelectedId, anchor: .center)
                           // print(vm.rowSelectedId)
                        }
                    })
                    .gesture(
                       DragGesture().onChanged { value in
                           if value.translation.height <= 50 {
                               isShowPhoto = true
                               isScrollActive = true

                           }
                          if value.translation.height > 0 {
                              isScrollActive = false
                              isShowPhoto = false
                          } else {
                              
                          }
                       }
                    )
                .padding(.bottom)
                }
            }
        }
    }
}

//
//struct ContactMediaView_Previews: PreviewProvider {
//    @ObservedObject var vm = ContactMediaViewModel()
//    static var previews: some View {
//        ContactMediaView(vm: vm)
//    }
//}


