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
    static let shared = UserRepository()
    
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
    
    // User의 lentalYn 업데이트
    func updateUserLentalYn(email: String, lentalYn: String) {
        db.collection("users").document(email).updateData(["lentalYn": lentalYn]) { error in
            if let error = error {
                print("Error updating lentalYn: \(error)")
            } else {
                // 업데이트 후 UserModel을 갱신합니다.
                self.retrieveUserData(email: email) { _ in
                }
            }
        }
    }
    
}



