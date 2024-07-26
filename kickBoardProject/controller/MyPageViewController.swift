//
//  MainPageViewController.swift
//  kickBoardProject
//
//  Created by Soo Jang on 7/23/24.
//

import UIKit
import SnapKit

class MyPageViewController: UIViewController {
    
    var myPageView: MyPageView!

    var kickBoardItems: [(String, Int)] = [("first kickboard", 1), ("second kickboard", 25), ("third kickboard", 51), ("fourth kickboard", 75), ("fiveth kickboard", 100)]
    let useItems = ["first used 1000$", "second usage 500$", "third usage 700$", "fourth usage 800$", "fiveth usage 900$"]
    
    override func loadView() {
        super.loadView()
        myPageView = MyPageView(frame: self.view.frame)
        self.view = myPageView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setNav()
        setTableView()
    }
    
    func setTableView() {
        myPageView.kickboardTableView.dataSource = self
        myPageView.kickboardTableView.delegate = self
        myPageView.historyTableView.dataSource = self
        myPageView.historyTableView.delegate = self
    }
    
    func setNav() {
        self.navigationItem.title = UserModel.shared.getUser().name
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationController?.navigationBar.largeTitleTextAttributes = [ .foregroundColor : UIColor.black]
        let logoutButton = UIBarButtonItem(title: "로그아웃", style: .plain, target: self, action: #selector(logoutTapped))
        navigationItem.rightBarButtonItem = logoutButton
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
    func logoutTapped() {
        logoutAlert()
    }
    
    func logoutAlert(){
        let alert = UIAlertController(title: "로그아웃", message: "로그아웃 하시겠습니가?", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "네", style: .default) { action in
            guard let backVC = self.tabBarController?.navigationController else { return }
            backVC.popToRootViewController(animated: true)
            UserDefaults.standard.setValue("N", forKey: "autoLoginYn")
        }
        let noAction = UIAlertAction(title: "아니오", style: .cancel)
        alert.addAction(yesAction)
        alert.addAction(noAction)
        present(alert, animated: true, completion: nil)
    }
}

extension MyPageViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == myPageView.kickboardTableView {
            return kickBoardItems.count
        } else if tableView == myPageView.historyTableView {
            return useItems.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == myPageView.kickboardTableView {
            let kickboardCell = tableView.dequeueReusableCell(withIdentifier: "AddedKickboardCell", for: indexPath) as! AddedKickboardCell
            kickboardCell.kickboardName.text = kickBoardItems[indexPath.row].0
            kickboardCell.batteryLabel.text = "\(kickBoardItems[indexPath.row].1)%"
            kickboardCell.batteryImageView.image = setBatteryImage(percent: kickBoardItems[indexPath.row].1)
            kickboardCell.selectionStyle = .none
            // 내 킥보드 이름, 배터리 잔량
            return kickboardCell
        } else if tableView == myPageView.historyTableView {
            let historyCell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath) as! HistoryCell
            historyCell.selectionStyle = .none
            return historyCell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if tableView == myPageView.kickboardTableView {
            let deleteAction = UIContextualAction(style: .destructive, title: "삭제하기") { (action, view, success ) in
                self.kickBoardItems.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                // 내 킥보드 삭제하는 코드
                
            }
            let config = UISwipeActionsConfiguration(actions: [deleteAction])
            config.performsFirstActionWithFullSwipe = false
            return config
        }
        return UISwipeActionsConfiguration()
    }
}
