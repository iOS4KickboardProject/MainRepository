//
//  ModelViewcontroller.swift
//  kickBoardProject
//
//  Created by 이득령 on 7/25/24.
//

import SnapKit
import UIKit

class ModelViewcontroller: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
     
        view.backgroundColor = .white
    }

}
extension ModelViewcontroller {
    func setNavigation() {
        self.navigationItem.title = "킥보드 ID"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationController?.navigationBar.largeTitleTextAttributes = [ .foregroundColor : UIColor.black]
    }
}
