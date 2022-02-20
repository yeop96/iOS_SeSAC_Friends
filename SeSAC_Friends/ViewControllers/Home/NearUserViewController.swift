//
//  NearUserViewController.swift
//  SeSAC_Friends
//
//  Created by yeop on 2022/02/15.
//

import UIKit
import SnapKit
import Toast
import JGProgressHUD

final class NearUserViewController: BaseViewController {
    var fromQueueDB = [FromQueueDB](){
        didSet{
            if fromQueueDB.isEmpty{
                tableView.isHidden = true
                emptyView.isHidden = false
            } else{
                tableView.isHidden = false
                emptyView.isHidden = true
            }
            tableView.reloadData()
        }
    }
    let emptyView = EmptyUIView(text: "아쉽게도 주변에 새싹이 없어요ㅠ")
    let tableView = UITableView()
    let progress = JGProgressHUD()
    var otherUID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchFreinds()
    }
    
    override func configure() {
        emptyView.changeHobbyButton.addTarget(self, action: #selector(changeHobbyButtonClicked), for: .touchUpInside)
        emptyView.reloadButton.addTarget(self, action: #selector(reloadButtonButtonClicked), for: .touchUpInside)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UserProfileTableViewCell.self, forCellReuseIdentifier: UserProfileTableViewCell.identifier)
        tableView.separatorStyle = .none
    }
    
    override func setupConstraints() {
        view.addSubview(emptyView)

        emptyView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    
    @objc func changeHobbyButtonClicked(){
        progress.show(in: view, animated: true)
        ServerService.shared.deleteRequestFrineds() { statusCode, data in
            switch statusCode{
            case ServerStatusCode.OK.rawValue:
                DispatchQueue.main.async {
                    print(statusCode, data)
                    UserData.matchingStatus = MatchingStatus.search.rawValue
                    self.navigationController?.popViewController(animated: true)
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
                        self.changeHobbyButtonClicked()
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
    @objc func reloadButtonButtonClicked(){
        searchFreinds()
    }
    @objc func matchButtonClicked(sender: UIButton){
        otherUID = self.fromQueueDB[sender.tag].uid
        let popUpViewController = PopUpViewController(titleText: "취미 같이 하기를 요청할게요!", messageText: "요청이 수락되면 30분 후에 리뷰를 남길 수 있어요")
        popUpViewController.confirmAction = {
            self.request()
            popUpViewController.dismiss(animated: false, completion: nil)
        }
        present(popUpViewController, animated: false, completion: nil)
    }
    
    //취미 요청
    func request(){
        ServerService.shared.postHobbyrequest(uid: otherUID) { statusCode, data in
            switch statusCode{
            case ServerStatusCode.OK.rawValue:
                DispatchQueue.main.async {
                    self.view.makeToast("취미 함께 하기 요청을 보냈습니다", duration: 3.0, position: .bottom)
                }
            case HobbyRequestStatusCode.USER_ALREADY_REQUEST.rawValue:
                DispatchQueue.main.async {
                    self.view.makeToast("상대방도 취미 함께 하기를 요청했습니다. 채팅방으로 이동합니다", duration: 1.0, position: .bottom)
                    //1초뒤 1_5_chatting 변환
                }
            case HobbyRequestStatusCode.USER_STOP_MATCHING.rawValue:
                DispatchQueue.main.async {
                    self.view.makeToast("상대방이 취미 함께 하기를 그만두었습니다", duration: 1.0, position: .bottom)
                }
            case ServerStatusCode.FIREBASE_TOKEN_ERROR.rawValue:
                ServerService.updateIdToken { result in
                    switch result {
                    case .success:
                        self.request()
                    case .failure(let error):
                        print(error.localizedDescription)
                        return
                    }
                }
            default:
                print("ERROR: ", statusCode)
            }
        }
    }
    
    //주변 찾기
    func searchFreinds(){
        progress.show(in: view, animated: true)
        ServerService.shared.postSearchFriedns(region: UserData.region, lat: UserData.lat, long: UserData.long) { statusCode, data in
            switch statusCode{
            case ServerStatusCode.OK.rawValue:
                DispatchQueue.main.async {
                    let searchedFriends = try? JSONDecoder().decode(SearchedFriends.self, from: data!)
                    self.fromQueueDB = searchedFriends!.fromQueueDB
                }
            case ServerStatusCode.FIREBASE_TOKEN_ERROR.rawValue:
                ServerService.updateIdToken { result in
                    switch result {
                    case .success:
                        self.searchFreinds()
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

extension NearUserViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fromQueueDB.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UserProfileTableViewCell.identifier, for: indexPath) as? UserProfileTableViewCell else {
             return UITableViewCell()
        }
        
        let user = fromQueueDB[indexPath.row]
        cell.profileBackImageView.image = SesacBackgroundImage(rawValue: user.background)?.sesacBackgroundUIImage()
        cell.profileUserImageView.image = SesacImage(rawValue: user.sesac)?.sesacUIImage()
        cell.nickNameLabel.text = user.nick
        
        for (index, element) in user.reputation.enumerated(){
            if element > 0{
                switch index {
                case 0:
                    cell.reputationsView.mannerButton.clicked()
                case 1:
                    cell.reputationsView.timeButton.clicked()
                case 2:
                    cell.reputationsView.fastButton.clicked()
                case 3:
                    cell.reputationsView.kindButton.clicked()
                case 4:
                    cell.reputationsView.handyButton.clicked()
                case 5:
                    cell.reputationsView.beneficialButton.clicked()
                default:
                    print("")
                }
            }
        }
        cell.hobbyData = user.hf.map{$0.lowercased() == "anything" ? "아무거나" : $0}
        if let review = user.reviews.first{
            cell.reviewLabel.text = review
            cell.reviewLabel.numberOfLines = 0
            cell.reviewLabel.textColor = .black
        }
        cell.matchButton.setTitle("요청하기", for: .normal)
        cell.matchButton.tag = indexPath.row
        cell.matchButton.addTarget(self, action: #selector(matchButtonClicked(sender:)), for: .touchUpInside)
         
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
