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
        label.textColor = .black
        return label
    }()

    private let kickboardImgView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "kickboardpic")
        return iv
    }()

    private let batteryLabel: UILabel = {
        let label = UILabel()
        label.text = "배터리 잔량"
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .black
        return label
    }()

    let batteryPercentageLabel: UILabel = {
        let label = UILabel()
        label.text = "75%"
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .black
        return label
    }()

    let batteryImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = UIImage(systemName: "battery.75percent")
        iv.tintColor = .black
        return iv
    }()

    private lazy var batteryView: UIView = {
        let v = UIView()
        [batteryPercentageLabel, batteryImageView].forEach { v.addSubview($0) }
        return v
    }()

    private let milegateLabel: UILabel = {
        let label = UILabel()
        label.text = "주행가능거리"
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .black
        return label
    }()

    let milegateDistanceLabel: UILabel = {
        let label = UILabel()
        label.text = "10km"
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .black
        return label
    }()

    private lazy var batteryStackView: UIStackView = {
        let stv = UIStackView(arrangedSubviews: [batteryLabel, batteryView])
        stv.axis = .horizontal
        stv.distribution = .fillEqually
        return stv
    }()

    private lazy var milegateStackView: UIStackView = {
        let stv = UIStackView(arrangedSubviews: [milegateLabel, milegateDistanceLabel])
        stv.axis = .horizontal
        stv.distribution = .fillEqually
        return stv
    }()

    private lazy var batteryMilegateStackView: UIStackView = {
//        let stv = UIStackView(arrangedSubviews: [batteryLabel, batteryView, milegateLabel, milegateDistanceLabel])
        let stv = UIStackView(arrangedSubviews: [batteryStackView, milegateStackView])
        stv.axis = .vertical
        stv.distribution = .equalSpacing
        return stv
    }()

    let rentBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("대여하기", for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        btn.titleLabel?.textColor = .white
        btn.backgroundColor = .black
        btn.layer.cornerRadius = 16
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

        [titleLabel, kickboardImgView, batteryMilegateStackView, rentBtn].forEach {
            self.addSubview($0)
        }

        titleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(16)
        }

        kickboardImgView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.size.equalTo(CGSize(width: 100, height: 100))
        }
        rentBtn.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview().inset(24)
            $0.height.equalTo(48)
        }
        
        batteryMilegateStackView.snp.makeConstraints {
            $0.top.equalTo(kickboardImgView.snp.bottom).offset(64)
            $0.leading.trailing.equalToSuperview().inset(48)
            $0.bottom.equalTo(rentBtn.snp.top).offset(-64)
        }
        
        batteryImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.size.equalTo(CGSize(width: 24, height: 24))
        }
        
        batteryPercentageLabel.snp.makeConstraints {
            $0.trailing.equalTo(batteryImageView.snp.leading).offset(-8)
            $0.centerY.equalToSuperview()
        }
    }
}
