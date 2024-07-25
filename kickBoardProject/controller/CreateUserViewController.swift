//
//  CreateUserViewController.swift
//  kickBoardProject
//
//  Created by 백시훈 on 7/23/24.
//

import Foundation
import UIKit
import FirebaseFirestore
class CreateUserViewController: UIViewController, CreateUserViewDelegate{
    let createUserView = CreateUserView()
    var userModel: UserModel?
    var userRepository = UserRepository()
    override func loadView() {
        view = createUserView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createUserView.delegate = self
        setAction()
    }
    
    func setAction(){
        createUserView.createButton.addTarget(self, action: #selector(setAutoLoginYn), for: .touchDown)
    }
    
    private func createUserTapped(){
        if createUserView.emailTextField.text!.isEmpty{
            showAlert(message: "이메일을 입력해 주세요")
            return
        }
        if createUserView.pwdTextField.text!.isEmpty{
            showAlert(message: "비밀번호를 입력해 주세요")
            return
        }
        if createUserView.pwdCheckTextField.text!.isEmpty{
            showAlert(message: "비밀번호 확인 부분을 입력해 주세요")
            return
        }
        if createUserView.pwdCheckTextField.text! != createUserView.pwdTextField.text!{
            showAlert(message: "비밀번호를 다시 한번 확인해 주세요")
            return
        }
        if createUserView.nameTextField.text!.isEmpty{
            showAlert(message: "성함을 입력해 주세요")
            return
        }
        
        let data: [String: Any] = [
            "email": createUserView.emailTextField.text ?? "",
            "lentalYn": "N",
            "name": createUserView.nameTextField.text ?? "",
            "pwd": createUserView.pwdTextField.text ?? ""
        ]
        
        userRepository.createUser(data: data) { [weak self] error in
            if let error = error {
                print("Error writing document: \(error.localizedDescription)")
            } else {
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @objc func setAutoLoginYn(){
        let alert = UIAlertController(title: "확인", message: "이후 앱이 실행될 때 로그인 화면을 건너 뛰시겠습니까?", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "네", style: .default) { action in
            UserDefaults.standard.setValue("Y", forKey: "autoLoginYn")
            UserDefaults.standard.setValue(self.createUserView.emailTextField.text!, forKey: "email")
            self.createUserTapped()
        }
        let noAction = UIAlertAction(title: "아니오", style: .cancel) { action in
            UserDefaults.standard.setValue("N", forKey: "autoLoginYn")
            self.createUserTapped()
        }
        alert.addAction(yesAction)
        alert.addAction(noAction)
        present(alert, animated: true, completion: nil)
    }
    
    func showAlert(message: String){
        let alert = UIAlertController(title: "확인", message: "\(message)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
