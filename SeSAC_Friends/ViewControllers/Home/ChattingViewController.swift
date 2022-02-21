//
//  ChattingViewController.swift
//  SeSAC_Friends
//
//  Created by yeop on 2022/02/15.
//

import UIKit
import SnapKit
import Toast

final class ChattingViewController: BaseViewController {
    var matchingPartner = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configure() {
        title = matchingPartner
        navigationController?.changeNavigationBar(isClear: true)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "arrow"), style: .plain, target: self, action: #selector(rootBackButtonClicked))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "more"), style: .plain, target: self, action: #selector(moreButtonClicked))
        self.navigationController?.navigationBar.tintColor = .black
    }
    
    override func setupConstraints() {

    }
    
    @objc func rootBackButtonClicked(){
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func moreButtonClicked(){
        
    }
}
