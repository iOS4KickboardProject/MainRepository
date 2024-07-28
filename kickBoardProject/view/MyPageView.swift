//
//  MyPageView.swift
//  kickBoardProject
//
//  Created by Soo Jang on 7/23/24.
//

import UIKit
import SnapKit

class MyPageView: UIView {
    
    let statusLabel: UILabel = {
        let label = UILabel()
        label.text = "현재 이용중이 아닙니다"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    let statusView: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        return v
    }()
// 빌린 킥보드 아이디 레이블
    let kickboardIDLabel: UILabel = {
        let label = UILabel()
        label.text = "1RT8-86Y5-IATE-C85L"
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    let batteryPercentageLabel: UILabel = {
        let label = UILabel()
        label.text = "75%"
//        label.textAlignment = .right
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
// MARK: 킥보드 반납 버튼
    let returnButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("반납하기", for: .normal)
        btn.layer.cornerRadius = 18
        btn.backgroundColor = .black
        btn.titleLabel?.textColor = .white
        return btn
    }()
    
    lazy var usingKickboardStackView: UIStackView = {
        let stv = UIStackView(arrangedSubviews: [kickboardIDLabel, batteryPercentageLabel, batteryImageView])
        stv.axis = .horizontal
        stv.distribution = .equalSpacing
        return stv
    }()
    
    let kickboardLabel: UILabel = {
        let label = UILabel()
        label.text = "내 킥보드"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .black
        return label
    }()

    let kickboardTableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = 60
        tableView.register(AddedKickboardCell.self, forCellReuseIdentifier: "AddedKickboardCell")
        tableView.backgroundColor = .white
        return tableView
    }()

    lazy var kickboardView: UIView = {
        let v = UIView()
        [kickboardLabel, kickboardTableView].forEach {
            v.addSubview($0)
        }
        return v
    }()

    let historyLabel: UILabel = {
        let label = UILabel()
        label.text = "이용내역"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .black
        return label
    }()

    let historyTableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = 60
        tableView.backgroundColor = .white
        tableView.register(HistoryCell.self, forCellReuseIdentifier: "HistoryCell")
        return tableView
    }()
    
    lazy var historyView: UIView = {
        let v = UIView()
        [historyLabel, historyTableView].forEach {
            v.addSubview($0)
        }
        return v
    }()
    
    lazy var tableViewStackView: UIStackView = {
        let stv = UIStackView(arrangedSubviews: [kickboardView, historyView])
        stv.axis = .vertical
        stv.distribution = .fillEqually
        stv.spacing = 8
        return stv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func viewChangeRental(status: String) {
        switch status {
        case "Y":
            [usingKickboardStackView, returnButton].forEach {
                statusView.addSubview($0)
            }
            usingKickboardStackView.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.width.equalTo(self.layer.frame.width * 0.7)
                $0.height.equalTo(30)
            }
            batteryImageView.snp.makeConstraints {
                $0.size.equalTo(CGSize(width: 24, height: 24))
            }
            returnButton.snp.makeConstraints {
                $0.height.equalTo(40)
                $0.centerX.equalToSuperview()
                $0.top.equalTo(usingKickboardStackView.snp.bottom).offset(8)
            }
            
        default:
            statusView.addSubview(statusLabel)
            statusLabel.snp.makeConstraints {
                $0.center.equalToSuperview()
            }
        }
    }
    
    private func configureUI() {
        self.backgroundColor = .white
        [statusView, tableViewStackView].forEach {
            self.addSubview($0)
        }
        
        statusView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            $0.height.equalTo(self.frame.height / 6)
        }
        
        kickboardLabel.snp.makeConstraints {
            $0.trailing.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(16)
        }
        kickboardTableView.snp.makeConstraints {
            $0.top.equalTo(kickboardLabel.snp.bottom).offset(10)
            $0.left.right.bottom.equalToSuperview()
        }
        
        historyLabel.snp.makeConstraints {
            $0.trailing.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(16)
        }
        
        historyTableView.snp.makeConstraints {
            $0.top.equalTo(historyLabel.snp.bottom).offset(10)
            $0.left.right.bottom.equalToSuperview()
        }
        
        tableViewStackView.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalTo(statusView.snp.bottom)
        }
    }
}

