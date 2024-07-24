//
//  CreateUserView.swift
//  kickBoardProject
//
//  Created by 백시훈 on 7/23/24.
//

import Foundation
import UIKit
import SnapKit
class CreateUserView: UIView{
    private var currentIndex = 0
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    let joinLabel: UILabel = {
        let label = UILabel()
        label.text = "회원가입"
        label.font = .boldSystemFont(ofSize: 50)
        return label
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
        label.isHidden = true
        return label
    }()
    
    let pwdTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.placeholder = "비밀번호"
        textField.isSecureTextEntry = true
        textField.isHidden = true
        return textField
    }()
    let pwdTextFieldLine: UIView = {
        let uiView = UIView()
        uiView.backgroundColor = .black
        uiView.isHidden = true
        return uiView
    }()
    let pwdCheckLabel: UILabel = {
        let label = UILabel()
        label.text = "Password Check"
        label.isHidden = true
        return label
    }()
    
    let pwdCheckTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.placeholder = "비밀번호 확인"
        textField.isSecureTextEntry = true
        textField.isHidden = true
        return textField
    }()
    let pwdCheckTextFieldLine: UIView = {
        let uiView = UIView()
        uiView.backgroundColor = .black
        uiView.isHidden = true
        return uiView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.isHidden = true
        return label
    }()
    
    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.placeholder = "이름"
        textField.isHidden = true
        return textField
    }()
    let nameTextFieldLine: UIView = {
        let uiView = UIView()
        uiView.backgroundColor = .black
        uiView.isHidden = true
        return uiView
    }()
    let nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("다음", for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(tappedNextButton), for: .touchDown)
        return button
    }()
    let createButton: UIButton = {
        let button = UIButton()
        button.setTitle("계정생성", for: .normal)
        button.backgroundColor = .black
        button.isHidden = true
        button.layer.cornerRadius = 10
        return button
    }()
    func setupView(){
        backgroundColor = .white
        [joinLabel, emailLabel, emailTextField, emailTextFieldLine, pwdLabel, pwdTextField, pwdTextFieldLine, pwdCheckLabel, pwdCheckTextField, pwdCheckTextFieldLine, nameLabel,nameTextField, nameTextFieldLine, nextButton, createButton].forEach { addSubview($0) }
        
        joinLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.top.equalTo(safeAreaLayoutGuide)
        }
        emailLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.top.equalTo(joinLabel.snp.bottom).offset(60)
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
        pwdCheckLabel.snp.makeConstraints {
            $0.top.equalTo(pwdTextFieldLine.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(20)
        }
        pwdCheckTextField.snp.makeConstraints {
            $0.top.equalTo(pwdCheckLabel.snp.bottom)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(40)
        }
        pwdCheckTextFieldLine.snp.makeConstraints {
            $0.top.equalTo(pwdCheckTextField.snp.bottom).offset(2)
            $0.leading.equalTo(pwdCheckTextField.snp.leading)
            $0.trailing.equalTo(pwdCheckTextField.snp.trailing)
            $0.height.equalTo(1)
        }
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(pwdCheckTextFieldLine.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(20)
        }
        nameTextField.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(40)
        }
        nameTextFieldLine.snp.makeConstraints {
            $0.top.equalTo(nameTextField.snp.bottom).offset(2)
            $0.leading.equalTo(nameTextField.snp.leading)
            $0.trailing.equalTo(nameTextField.snp.trailing)
            $0.height.equalTo(1)
        }
        nextButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.top.equalTo(emailTextFieldLine.snp.bottom).offset(20)
        }
    }
    @objc func tappedNextButton() {
        let elements: [(UILabel, UITextField, UIView)] = [
            (pwdLabel, pwdTextField, pwdTextFieldLine),
            (pwdCheckLabel, pwdCheckTextField, pwdCheckTextFieldLine),
            (nameLabel, nameTextField, nameTextFieldLine)
        ]
        
        if currentIndex < elements.count {
            let (label, textField, line) = elements[currentIndex]
            label.isHidden = false
            textField.isHidden = false
            line.isHidden = false
            positionNextButton(index: currentIndex)
            currentIndex += 1
        }
    }
    private func positionNextButton(index: Int){
        if index < 2{
            nextButton.snp.remakeConstraints {
                $0.leading.equalToSuperview().offset(20)
                $0.trailing.equalToSuperview().offset(-20)
                
                switch index {
                    case 0:
                        $0.top.equalTo(pwdTextFieldLine.snp.bottom).offset(20)
                    case 1:
                        $0.top.equalTo(pwdCheckTextFieldLine.snp.bottom).offset(20)
                    default:
                        $0.top.equalToSuperview().offset(20)
                }
            }
        }else{
            nextButton.isHidden = true
            createButton.isHidden = false
            createButton.snp.makeConstraints {
                $0.bottom.equalToSuperview().offset(-50)
                $0.leading.equalToSuperview().offset(20)
                $0.trailing.equalToSuperview().offset(-20)
                $0.height.equalTo(40)
            }
        }
        layoutSubviews()
    }
}
