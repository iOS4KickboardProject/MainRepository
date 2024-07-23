//
//  LoginController.swift
//  kickBoardProject
//
//  Created by 백시훈 on 7/23/24.
//

import Foundation
import UIKit

class LoginViewController: UIViewController{
    let loginView = LoginView()
    override func loadView() {
        view = loginView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setAction()
    }
    
    private func setAction(){
        loginView.joinButton.addTarget(self, action: #selector(joinButtonTapped), for: .touchDown)
        loginView.logInButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchDown)
    }
    
    @objc func loginButtonTapped(){
        let tabbar = TabBarController()
        navigationController?.pushViewController(tabbar, animated: true)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    @objc func joinButtonTapped(){
        let createUserViewController = CreateUserViewController()
        navigationController?.pushViewController(createUserViewController, animated: true)
    }
}
