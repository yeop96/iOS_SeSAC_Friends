//
//  FindUsersTabViewController.swift
//  SeSAC_Friends
//
//  Created by yeop on 2022/02/12.
//

import UIKit
import SnapKit
import Toast
import JGProgressHUD
import Tabman
import Pageboy

final class FindUsersTabViewController: TabmanViewController {
    var searchedFriends: SearchedFriends?
    let progress = JGProgressHUD()
    var viewControllers = [NearUserViewController(), AcceptViewController()]
    let bar = TMBar.ButtonBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configure()
    }
    
    func configure() {
        title = "새싹 찾기"
        navigationController?.changeNavigationBar(isClear: true)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "arrow"), style: .plain, target: self, action: #selector(rootBackButtonClicked))
        self.navigationController?.navigationBar.tintColor = .black
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "찾기중단", style: .plain, target: self, action: #selector(stopButtonClicked))
        navigationItem.rightBarButtonItem?.setTitleTextAttributes([.foregroundColor: UIColor.black, .font: UIFont().Title3_M14], for: .normal)
        
        self.dataSource = self
        settingTabBar(bar: bar)
        addBar(bar, dataSource: self, at: .top)
    }
    
    @objc func rootBackButtonClicked(){
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func stopButtonClicked(){
        
        progress.show(in: view, animated: true)
        ServerService.shared.deleteRequestFrineds() { statusCode, data in
            switch statusCode{
            case ServerStatusCode.OK.rawValue:
                DispatchQueue.main.async {
                    print(statusCode, data)
                    UserData.matchingStatus = MatchingStatus.search.rawValue
                    self.navigationController?.popToRootViewController(animated: true)
                }
            case DeleteQueueStatusCode.ALREADY_MATCHING.rawValue:
                DispatchQueue.main.async {
                    self.view.makeToast("누군가와 취미를 함께하기로 약속하셨어요!", duration: 3.0, position: .top)
                    //채팅 화면(1_5_chatting)으로 이동
                }
            case ServerStatusCode.FIREBASE_TOKEN_ERROR.rawValue:
                ServerService.updateIdToken { result in
                    switch result {
                    case .success:
                        self.stopButtonClicked()
                    case .failure(let error):
                        print(error.localizedDescription)
                        return
                    }
                }
            default:
                print("ERROR: ", statusCode)
            }
        }
        self.progress.dismiss(animated: true)
    }
    
    func settingTabBar (bar : TMBar.ButtonBar) {
        bar.layout.transitionStyle = .snap
        bar.layout.alignment = .centerDistributed
        bar.layout.contentMode = .fit
        bar.backgroundView.style = .blur(style: .light)
        
        bar.buttons.customize { button in
            button.tintColor = .gray6
            button.selectedTintColor = .green
            button.font = UIFont().Title4_R14
            button.selectedFont = UIFont().Title3_M14
        }
        
        bar.indicator.weight = .custom(value: 2)
        bar.indicator.tintColor = .green
    }
}


extension FindUsersTabViewController: PageboyViewControllerDataSource, TMBarDataSource {
    
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        switch index {
        case 0:
            return TMBarItem(title: "주변 새싹")
        case 1:
            return TMBarItem(title: "받은 요청")
        default:
            let title = "Page \(index)"
            return TMBarItem(title: title)
        }
    }
    
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllers.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController,
                        at index: PageboyViewController.PageIndex) -> UIViewController? {
        let vc = NearUserViewController()
        vc.searchedFriends = self.searchedFriends
        
        return index == 0 ? vc : AcceptViewController()
        //return viewControllers[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }
}
