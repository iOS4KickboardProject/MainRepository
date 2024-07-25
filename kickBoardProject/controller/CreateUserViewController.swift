//
//  CreateUserViewController.swift
//  kickBoardProject
//
//  Created by 백시훈 on 7/23/24.
//

import Foundation
import UIKit
import FirebaseFirestore
class CreateUserViewController: UIViewController{
    let createUserView = CreateUserView()
    var db: Firestore!
    var userModel: UserModel?
    override func loadView() {
        view = createUserView
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        setAction()
    }
    
    func setAction(){
        createUserView.createButton.addTarget(self, action: #selector(createUserTapped), for: .touchDown)
    }
    
    @objc func createUserTapped(){
        
        db.collection("users").document(createUserView.emailTextField.text!).setData([
            "autoLoginYn": "N",
            "email": "\(createUserView.emailTextField.text!)",
            "lentalYn": "N",
            "name": "\(createUserView.nameTextField.text!)",
            "pwd": "\(createUserView.pwdTextField.text!)"
        ]){ err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    
}
