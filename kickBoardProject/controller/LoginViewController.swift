//
//  LoginController.swift
//  kickBoardProject
//
//  Created by 백시훈 on 7/23/24.
//

import Foundation
import UIKit
import FirebaseFirestore
class LoginViewController: UIViewController{
    let loginView = LoginView()
    let userRepository = UserRepository()
    var user: UserStruct!
    override func loadView() {
        view = loginView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        retrieveAutoLogin()
    }
    func retrieveAutoLogin(){
        let autoLoginYn = UserDefaults.standard.string(forKey: "autoLoginYn")
        guard let autoLoginYn = autoLoginYn else {
            setAction()
            return
        }
        if autoLoginYn == "Y"{
            guard let email = UserDefaults.standard.string(forKey: "email") else { return }
            userRepository.retrieveUserData(email: email){ [weak self] user in
                guard let self = self else { return }
                self.user = user
                Pushtabbar()
            }
            
        }else{
            setAction()
        }
    }
    
    func setupLogInViewController(){
        let loginView = LoginViewController()
        addChild(loginView)
        self.view.addSubview(loginView.view)
        loginView.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        loginView.didMove(toParent: self)
    }
    private func setAction(){
        loginView.joinButton.addTarget(self, action: #selector(joinButtonTapped), for: .touchDown)
        loginView.logInButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchDown)
    }
    
    private func Pushtabbar(){
        let tabbar = TabBarController()
        navigationController?.pushViewController(tabbar, animated: true)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    @objc func joinButtonTapped(){
        let createUserViewController = CreateUserViewController()
        navigationController?.pushViewController(createUserViewController, animated: true)
    }
    
    ///조회 후 로그인
    @objc func loginButtonTapped() {
        userRepository.retrieveUserData(email: loginView.emailTextField.text!){ [weak self] user in
            guard let self = self else { return }
            self.user = user

            if let user = user, user.email == loginView.emailTextField.text!, user.pwd == loginView.pwdTextField.text! {
                self.Pushtabbar()
            } else {
                print("로그인 불가 alert추가")
            }
        }
    }
    

    
    
}
