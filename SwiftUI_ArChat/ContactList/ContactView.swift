//
//  ContactView.swift
//  SwiftUI_ArChat
//
//  Created by Никита Ананьев on 04.04.2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct ContactView: View {
    var name: String
    var image: String
    @Binding var recentMessages: Int
    var text: String
    var time: String
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                HStack {
                    WebImage(url: URL(string: image))
                        .resizable()
                        .scaledToFill()
                        .frame(width: 80, height: 80)
                        .cornerRadius(40)
                        .shadow(color: .gray, radius: 1, x: -1, y: 2)
                    VStack {
                        HStack {
                            Text(name)
                                .bold()
                            Spacer()
                        }
                        HStack {
                            Text(text)
                                .foregroundColor(.gray)
                                .lineLimit(0)
                            Spacer()
                        }
                    }
                    ZStack {
                        
                        VStack {
                            Text(time)
                                .foregroundColor(.gray)
                                .padding()
                            ZStack {
                                RoundedRectangle(cornerRadius: 12)
                                    .foregroundColor(.blue)
                                    .frame(width: 40, height: 30)
                                Text(recentMessages.description)
                                    .foregroundColor(.white)
                            }
                        }
                    }
                }
                .frame(width: geometry.size.width, height: 100, alignment: .center)
            }
        }
        .frame(height: 100)
    }
}


