//
//  MyInformationManagementViewController.swift
//  SeSAC_Friends
//
//  Created by yeop on 2022/02/02.
//

import UIKit
import SnapKit

class MyInformationManagementViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func configure() {
        title = "정보 관리"
        backConfigure()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(saveButtonClicked))
        navigationItem.rightBarButtonItem?.setTitleTextAttributes([.foregroundColor: UIColor.black, .font: UIFont().Title3_M14], for: .normal)
        
    }
    
    override func setupConstraints() {
    }
    
    @objc func saveButtonClicked(){
    }
}
