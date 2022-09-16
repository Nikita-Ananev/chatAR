//
//  ARData.swift
//  SwiftUI_ArChat
//
//  Created by Никита Ананьев on 19.01.2022.
//

import ARKit
import Combine

protocol ARDataDelegate {
    // получить данные об изменении Позиции по Х
    func xPositionChanged(x: CGFloat)
    
    // получить данные об изменении Позиции по Y
    func yPositionChanged(y: CGFloat)
    
    // получить данные об изменении Позиции по Z
    func zPositionChanged(z: CGFloat)
    func stopSession()
}

final class ARData: NSObject, ObservableObject {

    static var shared = ARData()
    
    var mainMenuDelegate: ARDataDelegate?
    var contactsDelegate: ARDataDelegate?
    var chatDelegate: ARDataDelegate?
    var contactMediaDelegate: ARDataDelegate?
    var skipCounter = 0

    @Published var arView: ARSCNView!
    @Published var isSessionRunning = false
    @Published var xPosition: Float = 0
    @Published var yPosition: Float = 0
    @Published var zPosition: Float = 0
    @Published var face = SCNNode()
    
    
    override init() {
        super.init()
        arView = ARSCNView(frame: .zero)
        arView.delegate = self
    }
    func startSession() {
        let configuration = ARFaceTrackingConfiguration()
        arView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors, .resetSceneReconstruction])
        isSessionRunning = true


        
    }
    func stopSession() {
        isSessionRunning = false
        skipCounter = 0
        arView.session.pause()
    }
    func restartSession() {
        stopSession()
        startSession()
    }
    
    
}
extension ARData: ARSCNViewDelegate {
    
    
    func renderer(_ renderer: SCNSceneRenderer, willRenderScene scene: SCNScene, atTime time: TimeInterval) {
        guard let pointOfView = arView.pointOfView else { return }
        let transform = pointOfView.transform
        let orientation = SCNVector3(-transform.m31, -transform.m32, transform.m33)
        let location = SCNVector3(transform.m41, transform.m42, transform.m43)
        let currentPositionOfCamera = orientation + location
        print(skipCounter)
     //   skipCounter += 1
      //  if skipCounter > 20 {
            sendPositionToDelegates(x: CGFloat(currentPositionOfCamera.x), y: CGFloat(currentPositionOfCamera.y))

       // }

    
        
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        DispatchQueue.main.async {
            self.face = node
        }
    }
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        getInfo()
    }
    func getInfo() {
        DispatchQueue.main.async {
        //    print(self.face.position.z.description)
        //    self.delegate?.zPositionChanged(x: CGFloat(self.face.position.z))


        }
    }
    
    
    func sendPositionToDelegates(x: CGFloat, y:CGFloat) {
        
        self.mainMenuDelegate?.xPositionChanged(x: x)
        
        self.contactsDelegate?.yPositionChanged(y: y)
        
        self.chatDelegate?.yPositionChanged(y: y)
        
        self.contactMediaDelegate?.yPositionChanged(y: y)
        
    }

}



func +(lhv:SCNVector3, rhv:SCNVector3) -> SCNVector3 {
     return SCNVector3(lhv.x + rhv.x, lhv.y + rhv.y, lhv.z + rhv.z)
}

