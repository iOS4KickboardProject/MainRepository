//
//  Kickboard.swift
//  kickBoardProject
//
//  Created by 박승환 on 7/24/24.
//

import Foundation

class KickBoard {
    static let shared = KickBoard()
    private var kickBoards: [KickboardStruct] = []
    
    private init() {
        NotificationCenter.default.addObserver(self, selector: #selector(didAddKickboardInfo(_:)), name: .didAddKickboardInfo, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didUpdateKickboardStatus(_:)), name: .didUpdateKickboardStatus, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(didDeleteKickboardInfo(_:)), name: .didDeleteKickboardInfo, object: nil)
    }
    
    func updateKickBoards(with kickboards: [KickboardStruct]) {
        self.kickBoards = kickboards
    }
    
    func setKickBoards() -> [KickboardStruct] {
        return kickBoards
    }
    
    func addKickBoard(_ kickboardInfo: KickboardStruct) {
        KickboardRepository.shared.addKickboardInfo(kickboardInfo)
    }
    
    func updateKickboardStatus(id: String, newStatus: String) {
        KickboardRepository.shared.updateKickboardStatus(id: id, newStatus: newStatus)
    }
    
    func deleteKickBoard(id: String) {
        KickboardRepository.shared.deleteKickboard(id: id)
    }

    @objc private func didAddKickboardInfo(_ notification: Notification) {
        if let success = notification.userInfo?["success"] as? Bool, success {
            print("Kickboard added successfully")
            KickboardRepository.shared.fetchKickboardInfos()
        } else {
            print("Failed to add kickboard")
        }
    }
    
    @objc private func didUpdateKickboardStatus(_ notification: Notification) {
        if let success = notification.userInfo?["success"] as? Bool, success {
//           let id = notification.userInfo?["id"] as? String,
//           let newStatus = notification.userInfo?["newStatus"] as? String {
//            // 업데이트 성공 시, 로컬 데이터도 업데이트
//            if let index = kickBoards.firstIndex(where: { $0.id == id }) {
//                kickBoards[index].status = newStatus
//            }
            KickboardRepository.shared.fetchKickboardInfos()
            print("Kickboard status updated successfully")
        } else {
            print("Failed to update kickboard status")
        }
    }
    
    @objc private func didDeleteKickboardInfo(_ notification: Notification) {
        if let success = notification.userInfo?["success"] as? Bool, success,
           let id = notification.userInfo?["id"] as? String {
            // 삭제 성공 시, 로컬 데이터도 업데이트
            self.kickBoards.removeAll { $0.id == id }
            print("Kickboard deleted successfully")
        } else {
            print("Failed to delete kickboard")
        }
    }
    
    func myKickboardList() -> [KickboardStruct] {
        var list: [KickboardStruct] = []
        for i in kickBoards {
            if i.userEmail == UserModel.shared.getUser().email {
                list.append(i)
            }
        }
        return list
    }
}


struct KickboardStruct {
    let id: String
    let userEmail: String
    let battery: String
    let status: String
    let latitude: String
    let longitude: String
    
    init?(dictionary: [String: Any]) {
        guard let battery = dictionary["battery"] as? String,
              let id = dictionary["id"] as? String,
              let latitude = dictionary["latitude"] as? String,
              let longitude = dictionary["longitude"] as? String,
              let status = dictionary["status"] as? String,
              let userEmail = dictionary["userEmail"] as? String else { return nil }

        self.battery = battery
        self.id = id
        self.latitude = latitude
        self.longitude = longitude
        self.status = status
        self.userEmail = userEmail
    }

    var dictionary: [String: Any] {
        return [
            "battery": battery,
            "id": id,
            "latitude": latitude,
            "longitude": longitude,
            "status": status,
            "userEmail": userEmail
        ]
    }
}
