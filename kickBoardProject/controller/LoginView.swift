//
//  LoginView.swift
//  kickBoardProject
//
//  Created by 백시훈 on 7/23/24.
//

import Foundation
import UIKit
import SnapKit
class LoginView: UIView{
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        
    }
    let logo: UIImageView = {
      let logo = UIImageView()
      logo.image = UIImage(named: "logo")
      logo.contentMode = .scaleAspectFit
      return logo
    }()
    let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "Email"
        return label
    }()
    
    let emailTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.placeholder = "이메일"
        return textField
    }()
    let emailTextFieldLine: UIView = {
        let uiView = UIView()
        uiView.backgroundColor = .black
        return uiView
    }()
    
    let pwdLabel: UILabel = {
        let label = UILabel()
        label.text = "Password"
        return label
    }()
    
    let pwdTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.placeholder = "비밀번호"
        textField.isSecureTextEntry = true
        return textField
    }()
    let pwdTextFieldLine: UIView = {
        let uiView = UIView()
        uiView.backgroundColor = .black
        return uiView
    }()
    let logInButton: UIButton = {
        let button = UIButton()
        button.setTitle("LogIn", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1.0
        button.layer.cornerRadius = 10
        return button
    }()
    let joinButton: UIButton = {
        let button = UIButton()
        button.setTitle("Join", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 10
        return button
    }()
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        
        return stackView
    }()
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        addGestureRecognizer(tapGesture)
    }

    @objc func dismissKeyboard() {
        endEditing(true)
    }
    
    private func setupView(){
        backgroundColor = .white
        setupTapGesture()
        [logInButton, joinButton].forEach {
            stackView.addArrangedSubview($0)
        }
        [emailLabel, emailTextField, emailTextFieldLine, pwdLabel, pwdTextField, pwdTextFieldLine, stackView, logo].forEach {
            addSubview($0)
        }
        logo.snp.makeConstraints {
            $0.top.equalToSuperview().offset(100)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        emailLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.top.equalTo(logo.snp.bottom).offset(20)
            $0.width.equalTo(70)
            $0.height.equalTo(20)
        }
        emailTextField.snp.makeConstraints {
            $0.top.equalTo(emailLabel.snp.bottom)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(40)
        }
        emailTextFieldLine.snp.makeConstraints {
            $0.top.equalTo(emailTextField.snp.bottom).offset(2)
            $0.leading.equalTo(emailTextField.snp.leading)
            $0.trailing.equalTo(emailTextField.snp.trailing)
            $0.height.equalTo(1)
        }
        pwdLabel.snp.makeConstraints {
            $0.top.equalTo(emailTextFieldLine.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(20)
        }
        pwdTextField.snp.makeConstraints {
            $0.top.equalTo(pwdLabel.snp.bottom)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(40)
        }
        pwdTextFieldLine.snp.makeConstraints {
            $0.top.equalTo(pwdTextField.snp.bottom).offset(2)
            $0.leading.equalTo(pwdTextField.snp.leading)
            $0.trailing.equalTo(pwdTextField.snp.trailing)
            $0.height.equalTo(1)
        }
        stackView.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-50)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(40)
        }
    }
}
