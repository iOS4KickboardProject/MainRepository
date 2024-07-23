//
//  MainPageViewController.swift
//  kickBoardProject
//
//  Created by Soo Jang on 7/23/24.
//

import UIKit
import SnapKit

class MyPageViewController: UIViewController {
    
    lazy var logoutBtn: UIBarButtonItem = {
        let btn = UIBarButtonItem()
        btn.title = "logout"
        btn.style = .plain
        btn.target = self
        btn.action = #selector(logoutTapped)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setNav()
    }
    
    func setNav() {
        self.navigationItem.title = "my page"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.largeTitleTextAttributes = [ .foregroundColor : UIColor.black]
        navigationItem.rightBarButtonItem = logoutBtn
    }
    
    @objc
    func logoutTapped() {
        guard let backVC = self.tabBarController?.navigationController else { return }
        backVC.popToRootViewController(animated: true)
    }
}
