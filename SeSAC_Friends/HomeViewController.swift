//
//  HomeViewController.swift
//  SeSAC_Friends
//
//  Created by yeop on 2022/01/21.
//

import UIKit
import SnapKit
import Toast

class HomeViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configure() {
        view.backgroundColor = .white
        navigationController?.changeNavigationBar(isClear: true)
    }
    
    override func setupConstraints() {

    }
}
