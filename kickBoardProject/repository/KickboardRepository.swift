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
}

extension Notification.Name {
    static let didAddKickboardInfo = Notification.Name("didAddKickboardInfo")
}
