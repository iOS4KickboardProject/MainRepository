//
//  UserModel.swift
//  kickBoardProject
//
//  Created by 백시훈 on 7/24/24.
//

import Foundation
class UserModel{
    static let shared = UserModel()
    private var user = UserStruct()

    let userRepository = UserRepository()

    private init() {
        
    }
    
    func fetchUser(user: UserStruct) {
        self.user = user
    }
    
    func updateUser(data: [String: Any]) {
        user.email = data["email"] as? String
        user.lentalYn = data["lentalYn"] as? String
        user.name = data["name"] as? String
        user.pwd = data["pwd"] as? String
    }
    
    func getUser() -> UserStruct {
        return user
    }
}
struct UserStruct{
    var email: String?
    var lentalYn: String?
    var name: String?
    var pwd: String?
}

