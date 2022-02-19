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
    let emptyView = EmptyUIView(text: "아쉽게도 주변에 새싹이 없어요ㅠ")
    let tableView = UITableView()
    var searchedFriends: SearchedFriends?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configure() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UserProfileTableViewCell.self, forCellReuseIdentifier: UserProfileTableViewCell.identifier)
        tableView.separatorStyle = .none
    }
    
    override func setupConstraints() {
//        view.addSubview(emptyView)
//
//        emptyView.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
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


extension NearUserViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 3
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UserProfileTableViewCell.identifier, for: indexPath) as? UserProfileTableViewCell else {
             return UITableViewCell()
        }
        cell.hobbyData = ["냥","냥냥파티","냥냥파티","냥냥파티"]
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
