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
    
    private init(kickBoards: [KickboardStruct]) {
        self.kickBoards = kickBoards
    }
    
    private init() {
        
    }
}


struct KickboardStruct {
    let id: String
    let userEmail: String
    let battery: String
    let status: String
    let latitude: String
    let longitude: String
}
