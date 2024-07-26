//
//  addedKickboardCell.swift
//  kickBoardProject
//
//  Created by Soo Jang on 7/25/24.
//

import UIKit
import SnapKit

class AddedKickboardCell: UITableViewCell {

    let kickboardName: UILabel = {
        let label = UILabel()
        label.text = "myKickboard"
        label.textColor = .black
        return label
    }()
    
    let batteryLabel: UILabel = {
        let label = UILabel()
        label.text = "75%"
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

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configureUI() {
        self.backgroundColor = .white
        [kickboardName, batteryLabel, batteryImageView].forEach {
            self.contentView.addSubview($0)
        }
        
        
        kickboardName.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview().inset(8)
        }

        batteryLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(batteryImageView.snp.leading).offset(-8)
        }
        
        batteryImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-16)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(CGSize(width: 24, height: 24))
        }
    }
    
}
