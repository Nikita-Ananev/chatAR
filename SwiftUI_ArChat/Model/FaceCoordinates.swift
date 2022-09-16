//
//  FaceCoordinates.swift
//  SwiftUI_ArChat
//
//  Created by Никита Ананьев on 11.04.2022.
//

import SwiftUI

struct FaceCoordinates {
    
    var x: CGFloat = 0
    var y: CGFloat = 0
    var z: CGFloat = 0
    
    mutating func resetCoordinates() {
        self.x = 0
        self.y = 0
        self.z = 0
    }
}
