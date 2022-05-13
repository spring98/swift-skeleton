//
//  NaverMap.swift
//  skeleton
//
//  Created by spring on 2022/05/13.
//

import Foundation
import SwiftUI
import NMapsMap

struct NaverMap : View {
    
//    @State var coord: (Double, Double) = (126.9784147, 37.5666805)
//    var body: some View {
//        ZStack {
//            VStack {
//                Button(action: {
//                    coord = (129.05562775, 35.1379222)
//                }) {
//                    Text("Move to Busan")
//                }
//                Button(action: {
//                    coord = (127.269311, 37.413294)
//                }) {
//                    Text("Move to Seoul somewhere")
//                }
//                Spacer()
//            }
//            .zIndex(1)
//
//            UIMapView(coord: (127.269311, 37.413294))
//                .edgesIgnoringSafeArea(.vertical)
//        }
//    }
    
    let locationService = LocationService()
    
    init() {
        print("1")
        
        locationService.requestLocation { coordinate in
            print(coordinate.latitude)
            print(coordinate.longitude)
        }
        print("2")
    }
    
    var body: some View {
            ZStack {
                UIMapView()
                    .edgesIgnoringSafeArea(.vertical)
                Button(action: {
                    print("클릭")
                    locationService.requestLocation { coordinate in
                        print(coordinate.latitude)
                        print(coordinate.longitude)
                    }
                }, label: {
                    Label("Allow tracking", systemImage: "location")
                })
            }
        }
}

struct UIMapView: UIViewRepresentable {
//    var coord: (Double, Double)
//
//    func makeUIView(context: Context) -> NMFNaverMapView {
//        let view = NMFNaverMapView()
//        view.showZoomControls = false
//        view.mapView.positionMode = .direction
//        view.mapView.zoomLevel = 17
//
//        return view
//    }
//
//    func updateUIView(_ uiView: NMFNaverMapView, context: Context) {
//        let coord = NMGLatLng(lat: coord.1, lng: coord.0)
//        let cameraUpdate = NMFCameraUpdate(scrollTo: coord)
//        cameraUpdate.animation = .fly
//        cameraUpdate.animationDuration = 1
//        uiView.mapView.moveCamera(cameraUpdate)
//
//    }
    
    func makeUIView(context: Context) -> NMFNaverMapView {
       
       let view = NMFNaverMapView()
       view.showZoomControls = false
       view.mapView.positionMode = .direction
       view.mapView.zoomLevel = 17
     
       return view
   }
       
   func updateUIView(_ uiView: NMFNaverMapView, context: Context) {}
}

