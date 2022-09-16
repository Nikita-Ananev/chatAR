//
//  PinotecaLogoView.swift
//  SwiftUI_ArChat
//
//  Created by Никита Ананьев on 30.03.2022.
//

import SwiftUI

struct WelcomeLogoView: View {
    var body: some View {
        VStack {
            Text("Welcome")
                .font(.custom("Apple SD Gothic Neo", size: 45))
                .multilineTextAlignment(.center)
                .foregroundStyle(
                    LinearGradient(
                        colors: [.cyan, .green, .orange, .red, .purple, .blue, .cyan],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
            Text("to")
                .font(.custom("Apple SD Gothic Neo", size: 25))
                .multilineTextAlignment(.center)
                .foregroundStyle(
                    LinearGradient(
                        colors: [.red, .purple, .blue, .cyan],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
            Text("Pinoteca")
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

struct PinotecaLogoView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeLogoView()
    }
}
