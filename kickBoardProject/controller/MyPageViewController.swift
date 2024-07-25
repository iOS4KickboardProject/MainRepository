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
    
    var kickBoardItems = ["first kickboard", "second kickboard", "third kickboard", "fourth kickboard", "fiveth kickboard"]
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
        myPageView.useTableView.dataSource = self
        myPageView.useTableView.delegate = self
    }
    
    func setNav() {
        self.navigationItem.title = "my page"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationController?.navigationBar.largeTitleTextAttributes = [ .foregroundColor : UIColor.black]
        let logoutButton = UIBarButtonItem(title: "로그아웃", style: .plain, target: self, action: #selector(logoutTapped))
        navigationItem.rightBarButtonItem = logoutButton
    }
    
    @objc
    func logoutTapped() {
        guard let backVC = self.tabBarController?.navigationController else { return }
        backVC.popToRootViewController(animated: true)
    }
}

extension MyPageViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == myPageView.kickboardTableView {
            return kickBoardItems.count
        } else if tableView == myPageView.useTableView {
            return useItems.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if tableView == myPageView.kickboardTableView {
            let kickboardCell = tableView.dequeueReusableCell(withIdentifier: "AddedKickboardCell", for: indexPath) as! AddedKickboardCell
            kickboardCell.kickboardName.text = kickBoardItems[indexPath.row]
            kickboardCell.selectionStyle = .none
            // 내 킥보드 이름, 배터리 잔량
            return kickboardCell
        } else if tableView == myPageView.useTableView {
            cell.textLabel?.text = useItems[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if tableView == myPageView.kickboardTableView {
            if editingStyle == .delete {
                kickBoardItems.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                // 내 킥보드 삭제하는 코드 넣기
            }
        }
    }
}
