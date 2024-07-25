//
//  UserRepository.swift
//  kickBoardProject
//
//  Created by 백시훈 on 7/24/24.
//

import Foundation
import FirebaseFirestore
import KakaoMapsSDK

class UserRepository {
    var db: Firestore!
    var user: UserStruct!
    
    //    var poiPositions: [MapPoint] = []
    
    var poiPositions: [MapPoint] = []
    
    
    init() {
        db = Firestore.firestore()
    }
    //데이터 조회
    func retrieveUserData(email: String, completion: @escaping (UserStruct?) -> Void){
        db.collection("users").document(email).getDocument { [weak self] (document, error) in
            guard let self = self else { return }
            if let document = document, document.exists {
                let data = document.data()
                if let data = data {
                    UserModel.shared.updateUser(data: data)
                    user = UserModel.shared.getUser()
                    completion(user)
                }
            } else {
                print("조회된 데이터가 없을때 alert추가")
            }
        }
    }
    //User 데이터 생성
    func createUser(data: [String: Any], completion: @escaping (Error?) -> Void) {
        if let email = data["email"] as? String {
            db.collection("users").document(email).setData(data) { err in
                completion(err)
            }
        }
    }
    
    func createPoi_Data(poi_ID: String, long: Double, lati: Double) {
        // Prepare the data to be uploaded
        let data: [String: Any] = [
            "map": [
                "longitude": "\(long)",
                "latitude": "\(lati)"
            ]
        ]
        // Set the data with merge option
        db.collection("Poi").document(poi_ID).setData(data, merge: true) { [weak self] error in
            if let error = error {
                print("Error writing document \(poi_ID): \(error)")
            } else {
                print("Document \(poi_ID) successfully written!")
                
                // Add the new MapPoint to poiPositions
                self?.poiPositions.append(MapPoint(longitude: long, latitude: lati))
            }
        }
    }
    
    //    func createPoi_Data(poi_ID: String, long: Double, lati: Double) {
    //           db.collection("Poi").document(poi_ID).setData(["map": ["longitude":"\(long)", "latitude": "\(lati)"]]) { error in
    //               if let error = error {
    //                   print("called Firebase:\(error)")
    //               } else {
    //                   print("success")
    //                   self.poiPositions.append(MapPoint(longitude: long, latitude: lati))
    //
    //
    //               }
    //           }
    //       }
    func fetchAllPois() {
        db.collection("Poi").getDocuments { [weak self] (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
                return
            }
                    for document in querySnapshot!.documents {
                let data = document.data()
                if let map = data["map"] as? [String: String],
                   let longitudeStr = map["longitude"],
                   let latitudeStr = map["latitude"],
                   let longitude = Double(longitudeStr),
                   let latitude = Double(latitudeStr) {
                    print("Fatch Done")
                    let mapPoint = MapPoint(
                        longitude: longitude,
                        latitude: latitude
                    )
                    self?.poiPositions.append(MapPoint(longitude: longitude, latitude: latitude))
                }
            }
        }
    }
}



