//
//  RocketModel.swift
//  gravity
//
//  Created by Braeden Hall on 2025-07-11.
//

import SwiftUI
import SceneKit

struct RocketOrientation {
    var pitch: CGFloat
    var roll: CGFloat
    var yaw: CGFloat
}

class RocketModel: ObservableObject {
    static let shared = RocketModel()
    
    let rad: CGFloat
    let len: CGFloat
    let numFins: Int
    
    @Published var orientation: RocketOrientation = RocketOrientation(pitch: 0.0, roll: 0.0, yaw: 0.0) {
        didSet { updateOrientationView() }
    }
    
    lazy var node: SCNNode = {
        let cylinder = SCNCylinder(radius: rad, height: len)
        let cylNode = SCNNode(geometry: cylinder)
        
        let cone = SCNCone(topRadius: 0.005, bottomRadius: rad, height: len / 3)
        let coneNode = SCNNode(geometry: cone)
        coneNode.position = SCNVector3(0, len / 2 + len / 6, 0)
        cylNode.addChildNode(coneNode)
        
        for i in 0..<numFins {
            let angle = (2.0 * .pi * CGFloat(i)) / CGFloat(numFins)

            let x = (rad + len / 11) * cos(angle)
            let z = (rad + len / 11) * sin(angle)
            
            let fin = SCNBox(width: len / 5, height: len / 4, length: 0.02, chamferRadius: 0.01)
            let finNode = SCNNode(geometry: fin)
            
            finNode.position = SCNVector3(x, -len / 3, z)
            finNode.eulerAngles = SCNVector3(0, angle, 0)
            
            cylNode.addChildNode(finNode)
        }
        
        return cylNode
    }()
    
    init (rad: CGFloat = 0.1, len: CGFloat = 1.0, numFins: Int = 4) {
        self.rad = rad
        self.len = len
        self.numFins = numFins
    }
    
    func setOreintation(pitch: Float, roll: Float, yaw: Float) {
        orientation.pitch = CGFloat(pitch)
        orientation.roll = CGFloat(roll)
        orientation.yaw = CGFloat(yaw)
    }
    
    func updateOrientationView() {
        node.eulerAngles = SCNVector3(orientation.pitch, orientation.roll, orientation.yaw)
    }
}
