//
//  ARDispayView.swift
//  SwiftUI_ArChat
//
//  Created by Никита Ананьев on 11.04.2022.
//

import SwiftUI
import ARKit


struct ARDisplayView: View {
    var body: some View {
        ARViewContainer()
    }
    
}
struct ARViewContainer: UIViewRepresentable {

    
    func makeUIView(context: Context) -> some UIView {
        return ARData.shared.arView
    }
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}
struct ARDisplayView_Previews: PreviewProvider {
    static var previews: some View {
        ARDisplayView()
    }
}
