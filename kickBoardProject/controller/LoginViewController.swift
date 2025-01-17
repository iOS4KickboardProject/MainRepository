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
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        retrieveAutoLogin()
        navigationController?.setNavigationBarHidden(false, animated: true)
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
                UserModel.shared.fetchUser(user: self.user)
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
        if loginView.emailTextField.text!.isEmpty{
            showAlert(message: "이메일를 작성해 주세요.")
            return
        }
        if loginView.pwdTextField.text!.isEmpty{
            showAlert(message: "비밀번호를 작성해 주세요.")
            return
        }
        setAutoLoginYn()
    }
    func setAutoLoginYn(){
        let alert = UIAlertController(title: "확인", message: "이후 앱이 실행될 때 로그인 화면을 건너 뛰시겠습니까?", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "네", style: .default) { action in
            UserDefaults.standard.setValue("Y", forKey: "autoLoginYn")
            UserDefaults.standard.setValue(self.loginView.emailTextField.text!, forKey: "email")
            self.retireveUserData()
        }
        let noAction = UIAlertAction(title: "아니오", style: .cancel) { action in
            UserDefaults.standard.setValue("N", forKey: "autoLoginYn")
            self.retireveUserData()
        }
        alert.addAction(yesAction)
        alert.addAction(noAction)
        present(alert, animated: true, completion: nil)
    }
    func retireveUserData(){
        userRepository.retrieveUserData(email: loginView.emailTextField.text!){ [weak self] user in
            guard let self = self else { return }
            self.user = user
            if let user = user, user.email == loginView.emailTextField.text!, user.pwd == loginView.pwdTextField.text! {
                self.Pushtabbar()
                UserModel.shared.fetchUser(user: user)
            } else {
                UserDefaults.standard.setValue("N", forKey: "autoLoginYn")
                showAlert(message: "로그인 정보를 다시 확인 해주세요.")
            }
        }
    }
    func showAlert(message: String){
        let alert = UIAlertController(title: "확인", message: "\(message)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
