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
    
    // ARView 라는 타입을 UIViewType 이라는 별명으로 사용하겠다.
    typealias UIViewType = ARView
    
    // initState 같은 메소드
    func makeUIView(context: Context) -> ARView {
        
        // ARView 객체를 생성하고
        // 이 객체로 body tracking 을 시작한다.
        //      tracking 내 session 을 주기적으로 처리한다.
        //          여러 앵커들 중에 하나의 앵커를 고른다.
        //              하나의 앵커를 ARBodyAnchor 로 캐스팅 한다.
        //                  스켈레톤이 쌔삥이면 앵커를 추가하고 이미 사용했다면 캐스팅된 앵커를 스켈레톤에 업데이트 한다.
        // 이 객체의 씬에 앵커를 추가한다.
        
        let arView = ARView(frame: .zero, cameraMode: .ar, automaticallyConfigureSession: true)
        arView.setupForBodyTracking()
        arView.scene.addAnchor(bodySkeletonAnchor)
        
        return arView
    }
    
    // build 같은 메소드
    func updateUIView(_ uiView: ARView, context: Context) {}
    
}

extension ARView : ARSessionDelegate{
    
    func setupForBodyTracking() {
        let config = ARBodyTrackingConfiguration()
        self.session.run(config)
        // 파티 책임자가 위임해주면 내가 처리하겠다.
        self.session.delegate = self
    }

    
    //    optional func session(_ session: ARSession, didUpdate frame: ARFrame)
    //    optional func session(_ session: ARSession, didAdd anchors: [ARAnchor])
    //    optional func session(_ session: ARSession, didUpdate anchors: [ARAnchor])
    //    optional func session(_ session: ARSession, didRemove anchors: [ARAnchor])
    
    // 첫번째 파티 참가자가 음식과 노래를 준비한다.
    public func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        for anchor in anchors {
            if let bodyAnchor = anchor as? ARBodyAnchor {
//                print("Update bodyAnchor")
//                let skeleton = bodyAnchor.skeleton
//                let rootJointTransform = skeleton.modelTransform(for: .root)!
//                let rootJointPosition = simd_make_float3(rootJointTransform.columns.3)
//                print("root : \(rootJointPosition)")
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
