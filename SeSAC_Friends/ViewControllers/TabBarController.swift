//
//  TabBarController.swift
//  SeSAC_Friends
//
//  Created by yeop on 2022/01/29.
//

import UIKit
import JGProgressHUD

final class TabBarController: UITabBarController , UITabBarControllerDelegate{
    let progress = JGProgressHUD()
    
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
        
        userCheck()
    }
    
    func userCheck() {
        progress.show(in: view, animated: true)
        ServerService.shared.getUserInfo { statusCode, json in
            switch statusCode{
            case ServerStatusCode.OK.rawValue:
                AppFirstLaunch.isAppLogin = true
                DispatchQueue.main.async {
                    UserData.background = json["background"].intValue
                    UserData.sesac = json["sesac"].intValue
                    UserData.nickName =  json["nick"].stringValue
                    UserData.gender = json["gender"].intValue
                    UserData.hobby = json["hobby"].stringValue
                    UserData.searchable = json["searchable"].intValue
                    UserData.ageMin = json["ageMin"].intValue
                    UserData.ageMax = json["ageMax"].intValue
                    UserData.myUID = json["uid"].stringValue
                }
            case ServerStatusCode.FIREBASE_TOKEN_ERROR.rawValue:
                ServerService.updateIdToken { result in
                    switch result {
                    case .success:
                        self.userCheck()
                    case .failure(let error):
                        print(error.localizedDescription)
                        return
                    }
                }
            case ServerStatusCode.UNREGISTERED_ERROR.rawValue:
                print("미가입 유저")
                DispatchQueue.main.async {
                    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
                    windowScene.windows.first?.rootViewController = UINavigationController(rootViewController: PhoneAuthViewController())
                    windowScene.windows.first?.makeKeyAndVisible()
                }
            default:
                print("ERROR: ", statusCode, json)
            }
        }
        self.progress.dismiss(animated: true)
    }
    
}
