//
//  RocketOrientation.swift
//  gravity
//
//  Created by Braeden Hall on 2025-07-11.
//

import SwiftUI
import SceneKit

struct RocketOrientationView: View {
    @StateObject private var rocket = RocketModel.shared

//    @State private var roll: Double = 0
//    @State private var pitch: Double = 0
//    @State private var yaw: Double = 0
    
    var body: some View {
        VStack {
            SceneKitView(nodes: [rocket.node])
                .frame(width: 400, height: 400)
            
//            VStack {
//                Slider(value: $rocket.orientation.pitch, in: -.pi...(.pi), step: 0.01) {
//                    Text("Pitch")
//                }
//                Slider(value: $rocket.orientation.yaw, in: -.pi...(.pi), step: 0.01) {
//                    Text("Yaw")
//                }
//                Slider(value: $rocket.orientation.roll, in: -.pi...(.pi), step: 0.01) {
//                    Text("Roll")
//                }
//            }
        }
    }
}

#Preview {
    RocketOrientationView()
}
