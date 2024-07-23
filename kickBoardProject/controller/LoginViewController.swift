//
//  LoginViewController.swift
//  kickBoardProject
//
//  Created by Soo Jang on 7/23/24.
//

import UIKit
import SnapKit

class LoginViewController: UIViewController {

    let btn: UIButton = {
       let btn = UIButton()
        btn.setTitle("login", for: .normal)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .red
        // Do any additional setup after loading the view.
        view.addSubview(btn)
        
        btn.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        
        btn.addAction(UIAction { _ in
            self.navigationController?.pushViewController(TabBarController(), animated: true)
            self.navigationController?.isNavigationBarHidden = true
//            let nextVC = TabBarController()
//            nextVC.modalPresentationStyle = .fullScreen
//            nextVC.modalTransitionStyle = .flipHorizontal
//            self.present(nextVC, animated: true)
        }, for: .touchUpInside)
        
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        self.navigationController?.isNavigationBarHidden = true

//    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
