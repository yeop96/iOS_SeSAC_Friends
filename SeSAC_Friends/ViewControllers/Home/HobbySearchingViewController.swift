//
//  HobbySearchingViewController.swift
//  SeSAC_Friends
//
//  Created by yeop on 2022/02/12.
//

import UIKit
import SnapKit
import Toast

class HobbySearchingViewController: BaseViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configure() {
        navigationController?.changeNavigationBar(isClear: true)
        backConfigure()
    }
    
    
    override func setupConstraints() {

    }
    
    @objc func plusButtonClicked(){
        
    }
}
