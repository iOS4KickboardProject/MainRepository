//
//  RentModalView.swift
//  kickBoardProject
//
//  Created by Soo Jang on 7/26/24.
//

import UIKit
import SnapKit

class RentModalView: UIView {

    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "some-kickboard-id"
        label.font = .systemFont(ofSize: 32, weight: .bold)
        return label
    }()
    
    let batteryLabel: UILabel = {
        let label = UILabel()
        label.text = "배터리 잔량"
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 24, weight: .bold)
        return label
    }()
    
    let batteryPercentageLabel: UILabel = {
        let label = UILabel()
        label.text = "75%"
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    let milegateLabel: UILabel = {
        let label = UILabel()
        label.text = "주행가능거리"
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 24, weight: .bold)
        return label
    }()
    
    let milegateDistanceLabel: UILabel = {
        let label = UILabel()
        label.text = "10km"
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    lazy var batteryMilegateStackView: UIStackView = {
        let stv = UIStackView(arrangedSubviews: [batteryLabel, batteryPercentageLabel, milegateLabel, milegateDistanceLabel])
        stv.axis = .vertical
        stv.distribution = .equalSpacing
        return stv
    }()
    
    let rentBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("대여하기", for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 24, weight: .regular)
        btn.titleLabel?.textColor = .white
        btn.backgroundColor = .black
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        self.backgroundColor = .white
        
        [titleLabel, batteryMilegateStackView, rentBtn].forEach {
            self.addSubview($0)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(16)
        }
        rentBtn.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview().inset(16)
        }
        batteryMilegateStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalTo(rentBtn.snp.top).offset(-16)
            
        }
        
        
        
    }
    

}
