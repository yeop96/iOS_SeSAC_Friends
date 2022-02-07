//
//  UIViewController+Extension.swift
//  SeSAC_Friends
//
//  Created by yeop on 2022/02/06.
//

import Foundation
import UIKit

extension UIViewController {
    func showPopUp(title: String? = nil,
                   message: String? = nil) {
        let popUpViewController = PopUpViewController(titleText: title,
                                                      messageText: message)
        showPopUp(popUpViewController: popUpViewController)
    }


    private func showPopUp(popUpViewController: PopUpViewController) {
        present(popUpViewController, animated: false, completion: nil)
    }
    
    //showPopUp(title: "", message: "")
}
