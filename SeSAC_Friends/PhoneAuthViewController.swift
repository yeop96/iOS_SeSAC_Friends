//
//  PhoneAuthViewController.swift
//  SeSAC_Friends
//
//  Created by yeop on 2022/01/19.
//

import UIKit
import SnapKit
import SkyFloatingLabelTextField

class PhoneAuthViewController: BaseViewController {
    
    let textLabel = UILabel()
    let phoneTextField = InputTextField()
    let sendButton = DisableButton()
    let sendButtonActive = FillButton()
    let exception = Exception()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        phoneTextField.delegate = self
    }

    override func configure() {
        view.backgroundColor = .white
        
        textLabel.text = "새싹 서비스 이용을 위해\n휴대폰 번호를 입력해 주세요"
        textLabel.font = UIFont().Display1_R20
        textLabel.textColor = .black
        textLabel.numberOfLines = 2
        textLabel.textAlignment = .center
        
        phoneTextField.placeholder = "휴대폰 번호(-없이 숫자만 입력)"
        
        phoneTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        phoneTextField.keyboardType = .numberPad
        
        sendButton.setTitle("인증 문자 받기", for: .normal)
        sendButtonActive.setTitle("인증 문자 받기", for: .normal)
        
        sendButtonActive.isHidden = true
    }
    
    override func setupConstraints() {
        view.addSubview(textLabel)
        view.addSubview(phoneTextField)
        view.addSubview(sendButton)
        view.addSubview(sendButtonActive)
        
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
        
        sendButtonActive.snp.makeConstraints { make in
            make.top.equalTo(phoneTextField.snp.bottom).offset(72)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }
        
    }
    
}

extension PhoneAuthViewController: UITextFieldDelegate{
    @objc func textFieldDidChange(_ textfield: UITextField) {
        if let text = textfield.text {
            if !text.allSatisfy({ $0.isNumber }) {
                phoneTextField.errorColor = .error
                phoneTextField.errorMessage = "-없이 숫자만 입력"
                sendButton.isHidden = false
                sendButtonActive.isHidden = true
            } else if exception.IsValidPhone(phone: text){
                phoneTextField.errorColor = .success
                phoneTextField.errorMessage = "성공"
                sendButton.isHidden = true
                sendButtonActive.isHidden = false
            } else{
                phoneTextField.errorMessage = ""
                sendButton.isHidden = false
                sendButtonActive.isHidden = true
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        return newLength <= 12 // 숫자제한
    }
    
}
