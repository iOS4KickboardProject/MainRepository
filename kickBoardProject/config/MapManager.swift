//
//  MapManager.swift
//  kickBoardProject
//
//  Created by 이득령 on 7/24/24.
//

import UIKit
import SnapKit
import KakaoMapsSDK

class MapManager {
    static let manager = MapManager()
    private init() {}
    
    var mapController: KMController?
    var mapContainer: KMViewContainer?
    //MARK: - 지도 마커
    func addPositions(long: Double, lati: Double) {
        print("좌표 추가 됌")
        poiPositions.append(MapPoint(longitude: long, latitude: lati))
        print("등록되어있는 좌표들 \(poiPositions.count)")
    }
    
    
    var poiPositions: [MapPoint] = [
        MapPoint(longitude: 127.108678, latitude: 37.402001),
        MapPoint(longitude: 126.9137, latitude: 37.5492),
        MapPoint(longitude: 126.9137, latitude: 37.5493),
        MapPoint(longitude: 126.9137, latitude: 37.5494)
    ]
    
    
}

