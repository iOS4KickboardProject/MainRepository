//
//  CreateUserViewController.swift
//  kickBoardProject
//
//  Created by 백시훈 on 7/23/24.
//

import Foundation
import UIKit
class CreateUserViewController: UIViewController{
    let createUserView = CreateUserView()
    override func loadView() {
        view = createUserView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
