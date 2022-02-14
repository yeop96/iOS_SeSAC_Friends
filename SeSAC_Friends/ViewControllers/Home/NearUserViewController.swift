//
//  NearUserViewController.swift
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

final class NearUserViewController: BaseViewController {
    var searchedFriends: SearchedFriends?
    let progress = JGProgressHUD()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configure() {
        title = "새싹 찾기"
        navigationController?.changeNavigationBar(isClear: true)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "arrow"), style: .plain, target: self, action: #selector(rootBackButtonClicked))
        self.navigationController?.navigationBar.tintColor = .black
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "찾기중단", style: .plain, target: self, action: #selector(stopButtonClicked))
        navigationItem.rightBarButtonItem?.setTitleTextAttributes([.foregroundColor: UIColor.black, .font: UIFont().Title3_M14], for: .normal)
    }
    override func setupConstraints() {
        
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
}
