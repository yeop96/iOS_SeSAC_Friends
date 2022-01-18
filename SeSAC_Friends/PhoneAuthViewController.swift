//
//  PhoneAuthViewController.swift
//  SeSAC_Friends
//
//  Created by yeop on 2022/01/19.
//

import UIKit
import SnapKit

class PhoneAuthViewController: BaseViewController {
    
    let textLabel = UILabel()
    let phoneTextField = UITextField()
    let sendButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func configure() {
        view.backgroundColor = .white
        
        textLabel.text = "새싹 서비스 이용을 위해\n휴대폰 번호를 입력해 주세요"
        textLabel.numberOfLines = 2
        textLabel.textAlignment = .center
        
        phoneTextField.placeholder = "휴대폰 번호(-없이 숫자만 입력)"
        phoneTextField.borderStyle = .none
        
        sendButton.setTitle("인증 문자 받기", for: .disabled)
        sendButton.backgroundColor = .black
        sendButton.layer.cornerRadius = 8
    }
    
    override func setupConstraints() {
        view.addSubview(textLabel)
        view.addSubview(phoneTextField)
        view.addSubview(sendButton)
        
        textLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(125)
            make.centerX.equalToSuperview()
        }
        
        phoneTextField.snp.makeConstraints { make in
            make.top.equalTo(textLabel.snp.bottom).offset(64)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }
        
        sendButton.snp.makeConstraints { make in
            make.top.equalTo(phoneTextField.snp.bottom).offset(72)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }
        
    }
    
}
