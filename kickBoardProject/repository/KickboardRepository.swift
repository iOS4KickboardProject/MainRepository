//
//  KickboardRepository.swift
//  kickBoardProject
//
//  Created by 박승환 on 7/26/24.
//

import Foundation
import FirebaseFirestore

class KickboardRepository {
    private let db = Firestore.firestore()
    static let shared = KickboardRepository()
    
    private init() { }
    
    var kickboardID: String?
    var qrMOdalShow = false
    // 킥보드 정보 조회
    func fetchKickboardInfos() {
        db.collection("kickboardInfo").getDocuments(source: .server) { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                var kickboardInfos: [KickboardStruct] = []
                for document in querySnapshot!.documents {
                    if let kickboardInfo = KickboardStruct(dictionary: document.data()) {
                        kickboardInfos.append(kickboardInfo)
                    }
                }
                KickBoard.shared.updateKickBoards(with: kickboardInfos)
            }
        }
    }
    
    // 킥보드 추가
    func addKickboardInfo(_ kickboardInfo: KickboardStruct) {
        db.collection("kickboardInfo").document(kickboardInfo.id).setData(kickboardInfo.dictionary) { error in
            if let error = error {
                print("Error adding document: \(error)")
                NotificationCenter.default.post(name: .didAddKickboardInfo, object: nil, userInfo: ["success": false])
            } else {
                NotificationCenter.default.post(name: .didAddKickboardInfo, object: nil, userInfo: ["success": true])
            }
        }
    }
    
    // 킥보드 상태 업데이트
    func updateKickboardStatus(id: String, newStatus: String) {
        let docRef = db.collection("kickboardInfo").document(id)
        docRef.updateData(["status": newStatus]) { error in
            if let error = error {
                print("Error updating document: \(error)")
                NotificationCenter.default.post(name: .didUpdateKickboardStatus, object: nil, userInfo: ["success": false])
            } else {
                NotificationCenter.default.post(name: .didUpdateKickboardStatus, object: nil, userInfo: ["success": true, "id": id, "newStatus": newStatus])
            }
        }
    }
    
    // 킥보드 삭제
    func deleteKickboard(id: String) {
        let docRef = db.collection("kickboardInfo").document(id)
        docRef.delete { error in
            if let error = error {
                print("Error deleting document: \(error)")
                NotificationCenter.default.post(name: .didDeleteKickboardInfo, object: nil, userInfo: ["success": false])
            } else {
                NotificationCenter.default.post(name: .didDeleteKickboardInfo, object: nil, userInfo: ["success": true, "id": id])
            }
        }
    }
}

extension Notification.Name {
    static let didAddKickboardInfo = Notification.Name("didAddKickboardInfo")
    static let didUpdateKickboardStatus = Notification.Name("didUpdateKickboardStatus")
    static let didDeleteKickboardInfo = Notification.Name("didDeleteKickboardInfo")
}
