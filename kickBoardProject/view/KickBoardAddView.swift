//
//  KickBoardAddView.swift
//  kickBoardProject
//
//  Created by 박승환 on 7/23/24.
//

import UIKit
import SnapKit

class KickBoardAddView: UIView {
    let kickBoardIdLabel = UILabel()
    let kickBoardBattery = UITextField()
    let toolBar = UIToolbar()
    let pickerView = UIPickerView()
    var mapView = UIView()
    let reloadButton = UIButton()
    let data = ["100%", "90%", "80%", "70%", "60%", "50%", "40%", "30%", "20%", "10%", "0%"]
    var id = idSetting()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureLabel() {
        kickBoardIdLabel.text = "킥보드 ID : \(id)"
        kickBoardIdLabel.font = UIFont.boldSystemFont(ofSize: 20)
    }
    
    func configureBattery() {
        kickBoardBattery.borderStyle = .roundedRect
        kickBoardBattery.placeholder = "배터리 잔량을 선택하세요"
    }
    
    func configureBatteryToolbar() {
        toolBar.sizeToFit()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        
        let doneButtton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(donePicker))
        let flexbleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(cancelPicker))
        
        toolBar.setItems([cancelButton, flexbleSpace, doneButtton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        kickBoardBattery.inputAccessoryView = toolBar
    }
    
    func configureBatteryPicker() {
        pickerView.delegate = self
        pickerView.dataSource = self
        let screenWidth = UIScreen.main.bounds.width
        let pickerViewHeight: CGFloat = 300  // 기본 높이보다 높게 설정
        pickerView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: pickerViewHeight)
        
        kickBoardBattery.inputView = pickerView
    }
    
    func configureMap() {
        mapView.backgroundColor = .gray
    }
    
    func configureButton() {
        reloadButton.setTitle("현위치", for: .normal)
        reloadButton.addTarget(self, action: #selector(reloadButtonTapped), for: .touchUpInside)
        reloadButton.titleLabel?.font = .boldSystemFont(ofSize: 20)
        reloadButton.layer.cornerRadius = 10
        reloadButton.backgroundColor = .systemBlue
    }
    
    static func randomString() -> String {
        let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<4).map{ _ in letters.randomElement()! })
    }
    
    static func idSetting() -> String {
        var uuid = ""
        for i in 1...4 {
            uuid += randomString()
            if i != 4 {
                uuid += "-"
            }
        }
        return uuid
    }
    
    func resetId() {
        id = KickBoardAddView.idSetting()
        kickBoardIdLabel.text = "킥보드 ID : \(id)"
    }
    
    @objc func donePicker() {
        let row = pickerView.selectedRow(inComponent: 0)
        pickerView.selectRow(row, inComponent: 0, animated: false)
        kickBoardBattery.text = data[row]
        kickBoardBattery.resignFirstResponder()
    }

    @objc func cancelPicker() {
        kickBoardBattery.text = nil
        kickBoardBattery.resignFirstResponder()
    }
    
    @objc
    func reloadButtonTapped() {
        print("리로드 버튼 클릭")
    }
    
    func configureUI() {
        configureLabel()
        configureBattery()
        configureBatteryToolbar()
        configureBatteryPicker()
        configureMap()
        configureButton()
        self.backgroundColor = .white
        
        self.addSubview(kickBoardIdLabel)
        self.addSubview(kickBoardBattery)
        self.addSubview(mapView)
        self.addSubview(reloadButton)
        
        kickBoardIdLabel.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).offset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(30)
        }
        
        kickBoardBattery.snp.makeConstraints {
            $0.top.equalTo(kickBoardIdLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        mapView.snp.makeConstraints {
            $0.top.equalTo(kickBoardBattery.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(40)
            $0.height.equalTo(200)
        }
        
        reloadButton.snp.makeConstraints {
            $0.top.equalTo(mapView.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(30)
        }
    }
    
    
    
}

extension KickBoardAddView: UIPickerViewDelegate, UIPickerViewDataSource {
    
    // UIPickerViewDataSource 메소드
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data.count
    }

    // UIPickerViewDelegate 메소드
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return data[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("Selected: \(data[row])")
    }
}
