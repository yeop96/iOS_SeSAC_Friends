//
//  UINavigationController.swift
//  SeSAC_Friends
//
//  Created by yeop on 2022/01/21.
//

import UIKit

extension UINavigationController {
    
    // 완전 안보임
    func hideNavigationBar() {
        navigationBar.isHidden = true
    }
    
    // 투명하게 만들기 (버튼 등은 보임)
    func changeNavigationBar(isClear: Bool) {
        navigationBar.isHidden = false
        if isClear {
            navigationBar.shadowImage = UIImage()
            navigationBar.setBackgroundImage(UIImage(), for: .default)
        } else {
            navigationBar.shadowImage = nil
            navigationBar.setBackgroundImage(nil, for: .default)
        }
    }
}
