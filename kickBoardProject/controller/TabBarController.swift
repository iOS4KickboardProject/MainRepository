//
//  TabBarController.swift
//  kickBoardProject
//ㅁ
//  Created by Soo Jang on 7/23/24.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.backgroundColor = .white
        self.tabBar.tintColor = .black
        
        let myPageVC = UINavigationController(rootViewController: MyPageViewController())
        let kakaoMapVC = UINavigationController(rootViewController: KickboardAddController())
        let addVC = UINavigationController(rootViewController: KakaoMapViewController())

        
        kakaoMapVC.tabBarItem = UITabBarItem(title: "등록", image: UIImage(systemName: "plus.square"), selectedImage: UIImage(systemName: "plus.square.fill"))
//        mainVC.tabBarItem = UITabBarItem(title: "지도", image: UIImage(systemName: "map"), selectedImage: UIImage(systemName: "map.fill"))
        addVC.tabBarItem = UITabBarItem(title: "지도", image: UIImage(systemName: "map"), selectedImage: UIImage(systemName: "map.fill"))
        myPageVC.tabBarItem = UITabBarItem(title: "마이페이지", image: UIImage(systemName: "person.crop.circle"), selectedImage: UIImage(systemName: "person.crop.circle.fill"))
        
        //탭바에 등록할 컨트롤러 추가
        self.setViewControllers([kakaoMapVC, addVC, myPageVC], animated: true)
    }
}
