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
    
    let useLabel: UILabel = {
        let label = UILabel()
        label.text = "이용내역"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    let useTableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = 60
        tableView.backgroundColor = .white
        tableView.register(HistoryCell.self, forCellReuseIdentifier: "HistoryCell")
        return tableView
    }()
    
    lazy var useView: UIView = {
        let v = UIView()
        [useLabel, useTableView].forEach {
            v.addSubview($0)
        }
        return v
    }()
    
    lazy var tableViewStackView: UIStackView = {
        let stv = UIStackView(arrangedSubviews: [kickboardView, useView])
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
    
    private func configureUI() {
        self.backgroundColor = .white
        [statusLabel, tableViewStackView].forEach {
            self.addSubview($0)
        }
        
        statusLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(30)
        }
        
        kickboardLabel.snp.makeConstraints {
            $0.trailing.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(16)
        }
        kickboardTableView.snp.makeConstraints {
            $0.top.equalTo(kickboardLabel.snp.bottom).offset(10)
            $0.left.right.bottom.equalToSuperview()
        }
        
        useLabel.snp.makeConstraints {
            $0.trailing.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(16)
        }
        
        useTableView.snp.makeConstraints {
            $0.top.equalTo(useLabel.snp.bottom).offset(10)
            $0.left.right.bottom.equalToSuperview()
        }
        
        tableViewStackView.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalTo(statusLabel.snp.bottom).offset(30)
        }
    }
    
}
