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
    var db: Firestore!
    var userModel: UserModel?
    override func loadView() {
        view = loginView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        setAction()
    }
    //화면 터치했을때 키보드 내리기 삭제 금지
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    private func setAction(){
        loginView.joinButton.addTarget(self, action: #selector(joinButtonTapped), for: .touchDown)
        loginView.logInButton.addTarget(self, action: #selector(fetchUserData), for: .touchDown)
//        loginView.logInButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchDown)
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
    //수정중
    @objc func fetchUserData() {
        // 컬렉션 "users"에서 문서 "user1" 가져오기
        db.collection("users").document("user2").getDocument { [weak self] (document, error) in
            guard let self = self else { return }
            
            if let document = document, document.exists {
                let data = document.data()
                if let data = data {
                    UserModel.shared.updateUser(data: data)
                    print("UserModel: \(userModel)")
                }
            } else {
                print("조회된 데이터가 없을때")
            }
        }
        //탭바로 화면전환 코드
        let tabbar = TabBarController()
        navigationController?.pushViewController(tabbar, animated: true)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
}
