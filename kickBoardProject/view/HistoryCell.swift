//
//  HistoryCell.swift
//  kickBoardProject
//
//  Created by Soo Jang on 7/25/24.
//

import UIKit
import SnapKit

class HistoryCell: UITableViewCell {

    let kickboardNameLabel: UILabel = {
        let label = UILabel()
        label.text = "some random kickboard"
        label.textColor = .black
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "7월 25일 2024년"
        label.textColor = .black
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        self.backgroundColor = .white
        [kickboardNameLabel, dateLabel].forEach {
            self.addSubview($0)
        }
        kickboardNameLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(8)
        }
        dateLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-8)
        }
    }

}
