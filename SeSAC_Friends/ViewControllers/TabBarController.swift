//
//  TabBarController.swift
//  SeSAC_Friends
//
//  Created by yeop on 2022/01/29.
//

import UIKit

class TabBarController: UITabBarController , UITabBarControllerDelegate{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let homeViewController = HomeViewController()
        let homeNavigation = UINavigationController(rootViewController: homeViewController)
        
        let shopViewController = ShopViewController()
        shopViewController.title = "새싹샵"
        let shopNavigation = UINavigationController(rootViewController: shopViewController)
        
        let friendsViewController = FriendsViewController()
        friendsViewController.title = "새싹친구"
        let friendsNavigation = UINavigationController(rootViewController: friendsViewController)
        
        let myInformationViewController = MyInformationViewController()
        myInformationViewController.title = "내정보"
        let myInformationNavigation = UINavigationController(rootViewController: myInformationViewController)
        
        homeViewController.tabBarItem = UITabBarItem(title: "홈", image: UIImage(named: "homeInact"), selectedImage: UIImage(named: "homeAct"))
        shopViewController.tabBarItem = UITabBarItem(title: "새싹샵", image: UIImage(named: "shopInact"), selectedImage: UIImage(named: "shopAct"))
        friendsViewController.tabBarItem = UITabBarItem(title: "새싹친구", image: UIImage(named: "friendsInact"), selectedImage: UIImage(named: "friendsAct"))
        myInformationNavigation.tabBarItem = UITabBarItem(title: "내정보", image: UIImage(named: "myInact"), selectedImage: UIImage(named: "myAct"))
        
        
        setViewControllers([homeNavigation, shopNavigation, friendsNavigation, myInformationNavigation], animated: true)
        
        let appearance = UITabBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.backgroundColor = .white
        
        tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        }
        tabBar.tintColor = .green
    }
    
//    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
//        print(item)
//    }
}
