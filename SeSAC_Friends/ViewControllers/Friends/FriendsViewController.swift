//
//  FriendsViewController.swift
//  SeSAC_Friends
//
//  Created by yeop on 2022/01/29.
//

import UIKit
import SnapKit
import Toast

final class FriendsViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configure() {
        navigationController?.changeNavigationBar(isClear: true)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "friends_plus"), style: .plain, target: self, action: #selector(plusButtonClicked))
        self.navigationController?.navigationBar.tintColor = .black
    }
    
    override func setupConstraints() {

    }
    
    @objc func plusButtonClicked(){
        
    }
}

