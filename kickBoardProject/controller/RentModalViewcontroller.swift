//
//  ModelViewcontroller.swift
//  kickBoardProject
//
//  Created by 이득령 on 7/25/24.
//

import SnapKit
import UIKit

class RentModalViewcontroller: UIViewController {
    
    var rentModalView: RentModalView!
    var kickboard: KickboardStruct?

    override func loadView() {
        super.loadView()
        rentModalView = RentModalView(frame: self.view.frame)
        if let kickboard = kickboard, let percent = Int(kickboard.battery) {
            rentModalView.titleLabel.text = kickboard.id
            rentModalView.batteryPercentageLabel.text = "\(kickboard.battery)%"
            rentModalView.batteryImageView.image = setBatteryImage(percent: percent)
        }
        rentModalView.rentBtn.addTarget(self, action: #selector(lentalKickboard), for: .touchUpInside)
        self.view = rentModalView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        view.backgroundColor = .white
    }
    
    func setBatteryImage(percent: Int) -> UIImage {
        switch percent {
        case 0...24:
            return UIImage(systemName: "battery.0percent")!
        case 25...49:
            return UIImage(systemName: "battery.25percent")!
        case 50...74:
            return UIImage(systemName: "battery.50percent")!
        case 75...99:
            return UIImage(systemName: "battery.75percent")!
        case 100:
            return UIImage(systemName: "battery.100percent")!
        default:
            return UIImage(systemName: "x.circle")!
        }
    }

    @objc
    func lentalKickboard() {
        if let email = UserModel.shared.getUser().email, let id = kickboard?.id {
            UserRepository.shared.updateUserLentalYn(email: email, lentalYn: "Y")
            KickBoard.shared.updateKickboardStatus(id: id, newStatus: email)
            dismiss(animated: true) {
                NotificationCenter.default.post(name: Notification.Name("ModalDismissed"), object: nil)
            }
        }
    }
    
}
