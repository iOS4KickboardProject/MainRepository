//
//  History.swift
//  kickBoardProject
//
//  Created by 박승환 on 7/27/24.
//

import Foundation

class History {
    static let shared = History()
    private var Historys: [HistoryStruct] = []
    
    private init() {
        NotificationCenter.default.addObserver(self, selector: #selector(didAddHistoryInfo(_:)), name: .didAddHistoryInfo, object: nil)
    }

    func updateHistories(with histories: [HistoryStruct]) {
        self.Historys = histories
    }

    func getHistories() -> [HistoryStruct] {
        sortHistory()
        return Historys
    }

    func addHistory(_ historyInfo: HistoryStruct) {
        HistoryRepository.shared.addHistoryInfo(historyInfo)
    }

    func fetchHistories(for email: String) {
        HistoryRepository.shared.fetchHistoryInfos(for: email)
        sortHistory()
    }

    @objc private func didAddHistoryInfo(_ notification: Notification) {
        if let success = notification.userInfo?["success"] as? Bool, success {
            print("History added successfully")
            // 이메일을 기반으로 다시 히스토리를 가져옵니다.
            if let email = UserModel.shared.getUser().email {
                HistoryRepository.shared.fetchHistoryInfos(for: email)
                sortHistory()
            }
        } else {
            print("Failed to add history")
        }
    }
    
    func sortHistory() {
        let sortedHistoryArray = Historys.sorted {
            guard let date1 = dateFormatter.date(from: $0.returnTime),
                  let date2 = dateFormatter.date(from: $1.returnTime) else {
                return false
            }
            return date1 > date2
        }
        Historys = sortedHistoryArray
    }
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        return formatter
    }()
    
}

struct HistoryStruct {
    let email: String
    let kickboardId: String
    let returnTime: String
    
    init?(dictionary: [String: Any]) {
        guard let email = dictionary["email"] as? String,
              let kickboardId = dictionary["kickboardId"] as? String,
              let returnTime = dictionary["returnTime"] as? String else { return nil }

        self.email = email
        self.kickboardId = kickboardId
        self.returnTime = returnTime
    }

    var dictionary: [String: Any] {
        return [
            "email": email,
            "kickboardId": kickboardId,
            "returnTime": returnTime
        ]
    }
}
