//
//  AcceptViewController.swift
//  SeSAC_Friends
//
//  Created by yeop on 2022/02/15.
//

import UIKit
import SnapKit
import Toast

final class AcceptViewController: BaseViewController {
    var searchedFriends: SearchedFriends?
    let emptyView = EmptyUIView(text: "아직 받은 요청이 없어요ㅠ")
    
    override func loadView() {
        self.view = emptyView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configure() {
    
    }
    
    override func setupConstraints() {

    }
}
