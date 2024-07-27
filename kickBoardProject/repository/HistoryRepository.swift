//
//  HistoryRepository.swift
//  kickBoardProject
//
//  Created by 박승환 on 7/27/24.
//

import Foundation
import FirebaseFirestore

class HistoryRepository {
    private let db = Firestore.firestore()
    static let shared = HistoryRepository()
    
    func fetchHistoryInfos(for email: String) {
        db.collection("history").whereField("email", isEqualTo: email).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                var historyInfos: [HistoryStruct] = []
                for document in querySnapshot!.documents {
                    if let historyInfo = HistoryStruct(dictionary: document.data()) {
                        historyInfos.append(historyInfo)
                    }
                }
                History.shared.updateHistories(with: historyInfos)
            }
        }
    }

    func addHistoryInfo(_ historyInfo: HistoryStruct) {
        db.collection("history").addDocument(data: historyInfo.dictionary) { error in
            if let error = error {
                print("Error adding document: \(error)")
                NotificationCenter.default.post(name: .didAddHistoryInfo, object: nil, userInfo: ["success": false])
            } else {
                NotificationCenter.default.post(name: .didAddHistoryInfo, object: nil, userInfo: ["success": true])
            }
        }
    }
}
extension Notification.Name {
    static let didAddHistoryInfo = Notification.Name("didAddHistoryInfo")
}
