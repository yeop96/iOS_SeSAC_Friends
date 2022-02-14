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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configure() {
    }
    
    override func setupConstraints() {
        view.addSubview(emptyView)
        emptyView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
    }
    
    @objc func changeHobbyButtonClicked(){
        print("?")
    }
}
