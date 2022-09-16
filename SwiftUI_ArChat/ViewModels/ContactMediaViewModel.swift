//
//  ContactMediaViewModel.swift
//  SwiftUI_ArChat
//
//  Created by Никита Ананьев on 16.05.2022.
//

import SwiftUI
import Firebase
class ContactMediaViewModel: ObservableObject, ARDataDelegate {
    
    
    // MARK: AR-MODULE
    func stopSession() {
        selectionStopped()
    }
    
    @Published var imagesCount = 55
    @Published var rowSelectedId: Int = 0
    
    func xPositionChanged(x: CGFloat) {
    }
    
    var zeroFaceCoords = FaceCoordinates()
    
    func selectionStopped() {
         zeroFaceCoords.resetCoordinates()
        
    }
    
    func yPositionChanged(y: CGFloat) {
        if ARData.shared.isSessionRunning == false {
            return
        }
        if zeroFaceCoords.y == 0 {
            zeroFaceCoords.y = y
        }
        
        let moveValueY = y - zeroFaceCoords.y
        
        switch moveValueY {
        case -0.6 ... -0.05:
            withAnimation {
                DispatchQueue.main.async {
                    self.zeroFaceCoords.y = 0
                    self.previousView()

                }
            }
            
        case -0.05...0.05:
            withAnimation {
                DispatchQueue.main.async {
                }
            }
            
        case 0.05...0.6:
            withAnimation {
                DispatchQueue.main.async {
                    self.zeroFaceCoords.y = 0
                    self.nextView()

                }
                
            }
            
        default:
            print("nothing")
        }
    }
    func nextView() {
        if rowSelectedId != imagesCount - 1 && rowSelectedId + 3 <= imagesCount{
            rowSelectedId = rowSelectedId + 3
            
            print("АЙДИ ЯЧЕЙКИ увеличилось- \(rowSelectedId) " )
        }
    }
    
    // предыдущая страница
    func previousView() {
        if rowSelectedId != 0 && rowSelectedId - 3 >= 0{
            rowSelectedId = rowSelectedId - 3
            print("АЙДИ ЯЧЕЙКИ уменьшилось- \(rowSelectedId) " )
        }
    }
    
    func zPositionChanged(z: CGFloat) {
    }
    
    
}
