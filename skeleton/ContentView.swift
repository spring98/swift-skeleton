//
//  ContentView.swift
//  skeleton
//
//  Created by spring on 2022/05/09.
//

import SwiftUI
import RealityKit
import ARKit

struct ContentView : View {
    var body: some View {
        return ARViewContainer().edgesIgnoringSafeArea(.all)
    }
}


var bodySkeleton: BodySkeleton?
var bodySkeletonAnchor = AnchorEntity()



struct ARViewContainer: UIViewRepresentable {
    
    typealias UIViewType = ARView
    
    func makeUIView(context: Context) -> ARView {
        
        let arView = ARView(frame: .zero, cameraMode: .ar, automaticallyConfigureSession: true)
        
        // Load the "Box" scene from the "Experience" Reality File
//        let boxAnchor = try! Experience.loadBox()
        // Add the box anchor to the scene
        
        arView.setupForBodyTracking()
        
        
//        arView.scene.anchors.append(boxAnchor)
        arView.scene.addAnchor(bodySkeletonAnchor)
        
        return arView
        
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
}

extension ARView : ARSessionDelegate{
    
    func setupForBodyTracking() {
        let config = ARBodyTrackingConfiguration()
        self.session.run(config)
        
        self.session.delegate = self
    }
    
    
    public func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        for anchor in anchors {
            if let bodyAnchor = anchor as? ARBodyAnchor {
//                print("Update bodyAnchor")
//
//                let skeleton = bodyAnchor.skeleton
//
//                let rootJointTransform = skeleton.modelTransform(for: .root)!
//                let rootJointPosition = simd_make_float3(rootJointTransform.columns.3)
//                print("root : \(rootJointPosition)")
//
//
//                let leftHandTransform = skeleton.modelTransform(for: .leftHand)!
//                let leftHandOffset = simd_make_float3(leftHandTransform.columns.3)
//                let leftHandPosition = rootJointPosition + leftHandOffset
//                print("leftHand: \(leftHandPosition)")
                
                if let skeleton = bodySkeleton {
                    skeleton.udpate(with:bodyAnchor)
                } else {
                    let skeleton = BodySkeleton(for: bodyAnchor)
                    bodySkeleton = skeleton
                    bodySkeletonAnchor.addChild(skeleton)
                }
                
                
                
            }
        }
    }
}

class BodySkeleton: Entity {
    
    var joints: [String: Entity] = [:]
    
    required init(for bodyAnchor: ARBodyAnchor) {
        super.init()
        
        for jointName in ARSkeletonDefinition.defaultBody3D.jointNames {
            
            let jointRadius: Float = 0.03
            let jointColor: UIColor = .green
            
            let jointEntity = makeJoint(radius: jointRadius, color: jointColor)
            joints[jointName] = jointEntity
            self.addChild(jointEntity)
            
        }
    }
    
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    func makeJoint(radius: Float, color: UIColor) -> Entity {
        let mesh = MeshResource.generateSphere(radius: radius)
        let material = SimpleMaterial(color: color, roughness: 0.8, isMetallic: false)
        let modelEntity = ModelEntity(mesh: mesh, materials: [material])
        
        return modelEntity
    }
    
    func udpate(with bodyAnchor: ARBodyAnchor) {
        let rootPosition = simd_make_float3(bodyAnchor.transform.columns.3)
        
        for jointName in ARSkeletonDefinition.defaultBody3D.jointNames {
            if let jointEntity = joints[jointName], let jointTransform = bodyAnchor.skeleton.modelTransform(for: ARSkeleton.JointName(rawValue: jointName)) {
                let jointOffset = simd_make_float3(jointTransform.columns.3)
                jointEntity.position = rootPosition + jointOffset
                jointEntity.orientation = Transform(matrix: jointTransform).rotation
            }
            
        }
        
        
    }
    
}





#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
