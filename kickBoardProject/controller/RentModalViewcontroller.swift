//
//  ModelViewcontroller.swift
//  kickBoardProject
//
//  Created by 이득령 on 7/25/24.
//

import SnapKit
import UIKit

class RentModalViewcontroller: UIViewController {
    
    var rentModalView: RentModalView!

    override func loadView() {
        super.loadView()
        rentModalView = RentModalView(frame: self.view.frame)
        self.view = rentModalView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        view.backgroundColor = .white
    }

}
