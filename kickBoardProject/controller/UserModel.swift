//
//  UserModel.swift
//  kickBoardProject
//
//  Created by 백시훈 on 7/24/24.
//

import Foundation
class UserModel{
    static let shared = UserModel()
    private var user = userStruct()

    private init() {
        
    }
    
    func updateUser(data: [String: Any]) {
        user.autoLoginYn = data["autoLoginYn"] as? String
        user.email = data["email"] as? String
        user.lentalYn = data["lentalYn"] as? String
        user.name = data["name"] as? String
        user.pwd = data["pwd"] as? String
    }
}
struct userStruct{
    var autoLoginYn: String?
    var email: String?
    var lentalYn: String?
    var name: String?
    var pwd: String?
}
