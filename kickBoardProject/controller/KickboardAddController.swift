//
//  AddKickboardController.swift
//  kickBoardProject
//
//  Created by 박승환 on 7/23/24.
//

import UIKit

class KickboardAddController: UIViewController {
    
    let kickBoardAddView = KickBoardAddView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = kickBoardAddView
    }
}
