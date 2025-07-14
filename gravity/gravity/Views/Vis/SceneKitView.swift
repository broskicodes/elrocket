//
//  SceneKitView.swift
//  gravity
//
//  Created by Braeden Hall on 2025-07-11.
//

import SwiftUI
import SceneKit

struct SceneKitView: NSViewRepresentable {
    let nodes: [SCNNode]
    
    init (nodes: [SCNNode]) {
        self.nodes = nodes
    }
    
    func makeNSView(context: Context) -> SCNView {
        let sceneView = SCNView()
        sceneView.scene = setupScene()
        sceneView.allowsCameraControl = false
        sceneView.autoenablesDefaultLighting = true
        sceneView.backgroundColor = .black
        return sceneView
    }

    func updateNSView(_ uiView: SCNView, context: Context) {
        // Update logic if needed (e.g., orientation changes)
    }

    private func setupScene() -> SCNScene {
        let scene = SCNScene()

        for node in nodes {
            scene.rootNode.addChildNode(node)
        }
        
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(0, 0, 2)
        scene.rootNode.addChildNode(cameraNode)

        return scene
    }
}
