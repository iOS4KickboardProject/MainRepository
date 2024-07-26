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
    
    func fetchKickboardInfos() {
        db.collection("kickboardInfo").getDocuments { (querySnapshot, error) in
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
    
    func addKickboardInfo(_ kickboardInfo: KickboardStruct) {
        db.collection("kickboardInfo").addDocument(data: kickboardInfo.dictionary) { error in
            if let error = error {
                print("Error adding document: \(error)")
                NotificationCenter.default.post(name: .didAddKickboardInfo, object: nil, userInfo: ["success": false])
            } else {
                NotificationCenter.default.post(name: .didAddKickboardInfo, object: nil, userInfo: ["success": true])
            }
        }
    }
    
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
