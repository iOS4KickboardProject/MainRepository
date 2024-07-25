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
    //싱글톤 패턴 전역변수로 선언
       static let manager = MapManager()
       private init() {}
    
    
    //MARK: - 지도 마커
    func createPoiStyle() { // 보이는 스타일 정의
        guard let mapView = mapController?.getView("mapview") as? KakaoMap else {
          return
        }
        let labelManager = mapView.getLabelManager()
        let image = UIImage(named: "kickboard.png")
        let icon = PoiIconStyle(symbol: image, anchorPoint: CGPoint(x: 0.5, y: 1.0))
        let perLevelStyle = PerLevelPoiStyle(iconStyle: icon, level: 0)
        let poiStyle = PoiStyle(styleID: "blue", styles: [perLevelStyle])
        labelManager.addPoiStyle(poiStyle)
      }
      func createLabelLayer() { // 레이어생성
        guard let mapView = mapController?.getView("mapview") as? KakaoMap else { return }
        let labelManager = mapView.getLabelManager()
        let layer = LabelLayerOptions(layerID: "poiLayer", competitionType: .none, competitionUnit: .symbolFirst, orderType: .rank, zOrder: 10001)
        let _ = labelManager.addLabelLayer(option: layer)
      }
      func createPoi() {
        guard let mapView = mapController?.getView("mapview") as? KakaoMap else {
          return
        }
        let labelManager = mapView.getLabelManager()
        guard let layer = labelManager.getLabelLayer(layerID: "poiLayer") else {
          return
        }
        for (index, position) in poiPositions.enumerated() {
          let options = PoiOptions(styleID: "blue", poiID: "bluePoi_\(index)")
          if let poi = layer.addPoi(option: options, at: position) {
            poi.show()
          }
        }
      }
    //   좌표설정
      var poiPositions: [MapPoint] = [
        MapPoint(longitude: 127.108678, latitude: 37.402001),
        MapPoint(longitude: 126.9137, latitude: 37.5492),
        MapPoint(longitude: 126.9137, latitude: 37.5493),
        MapPoint(longitude: 126.9137, latitude: 37.5494)
      ]
    
}
