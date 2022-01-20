//
//  BaseView.swift
//  SeSAC_Friends
//
//  Created by yeop on 2022/01/19.
//

import UIKit
import SnapKit

class BaseViewController: UIViewController{
    
    override func viewDidLoad() {
        configure()
        setupConstraints()
    }
    
    func configure(){
        view.backgroundColor = .white
    }
    
    func setupConstraints(){
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
