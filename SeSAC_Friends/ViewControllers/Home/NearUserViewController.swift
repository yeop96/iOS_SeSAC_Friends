//
//  NearUserViewController.swift
//  SeSAC_Friends
//
//  Created by yeop on 2022/02/15.
//

import UIKit
import SnapKit
import Toast

final class NearUserViewController: BaseViewController {
    var fromQueueDB = [FromQueueDB]()
    let emptyView = EmptyUIView(text: "아쉽게도 주변에 새싹이 없어요ㅠ")
    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configure() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UserProfileTableViewCell.self, forCellReuseIdentifier: UserProfileTableViewCell.identifier)
        tableView.separatorStyle = .none
        
        if fromQueueDB.isEmpty{
            tableView.isHidden = true
            emptyView.isHidden = false
        } else{
            tableView.isHidden = false
            emptyView.isHidden = true
        }
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
        print("?")
    }
}


//struct f: Codable {
//    let uid, nick: String
//    let lat, long: Double
//    let reputation: [Int]
//    let hf, reviews: [String]
//    let gender, type, sesac, background: Int
//}
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
        print(user.reputation)
        cell.hobbyData = user.hf.map{$0.lowercased() == "anything" ? "아무거나" : $0}
        print(user.reviews)
        cell.matchButton.setTitle("요청하기", for: .normal)
         
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        print("df",UITableView.automaticDimension)
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
