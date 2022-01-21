//
//  PhoneAuthViewController.swift
//  SeSAC_Friends
//
//  Created by yeop on 2022/01/19.
//

import UIKit
import SnapKit
import AnyFormatKit
import Toast

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
        navigationController?.changeNavigationBar(isClear: true)
        
        textLabel.text = "새싹 서비스 이용을 위해\n휴대폰 번호를 입력해 주세요"
        textLabel.font = UIFont().Display1_R20
        textLabel.textColor = .black
        textLabel.numberOfLines = 2
        textLabel.textAlignment = .center
        
        phoneTextField.placeholder = "휴대폰 번호(-없이 숫자만 입력)"
        phoneTextField.keyboardType = .numberPad
        
        sendButton.setTitle("인증 문자 받기", for: .normal)
        sendButton.addTarget(self, action: #selector(sendButtonClicked), for: .touchUpInside)
        sendButtonActive.setTitle("인증 문자 받기", for: .normal)
        sendButtonActive.addTarget(self, action: #selector(sendButtonActiveClicked), for: .touchUpInside)
        
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
            make.top.equalTo(textLabel.snp.bottom).offset(76)
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
    @objc func sendButtonClicked(){
        let windows = UIApplication.shared.windows
        windows.last?.makeToast("잘못된 전화번호 형식입니다.", duration: 1.0, position: .top)
    }
    
    @objc func sendButtonActiveClicked(){
        let windows = UIApplication.shared.windows
        windows.last?.makeToast("전화 번호 인증 시작", duration: 1.0, position: .top)
        self.navigationController?.pushViewController(MessageAuthViewController(), animated: true)
    }
}

extension PhoneAuthViewController: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        textField.formatPhoneNumber(range: range, string: string)
        if let text = textField.text {
            if (text.count == 13 || text.count == 12) && !exception.IsValidPhone(phone: text){
                phoneTextField.errorColor = .error
                phoneTextField.errorMessage = "잘못된 전화번호 형식입니다."
                sendButton.isHidden = false
                sendButtonActive.isHidden = true
            } else if exception.IsValidPhone(phone: text){
                phoneTextField.errorColor = .success
                phoneTextField.errorMessage = "인증 문자를 받으세요!"
                sendButton.isHidden = true
                sendButtonActive.isHidden = false
            } else{
                phoneTextField.errorMessage = ""
                sendButton.isHidden = false
                sendButtonActive.isHidden = true
            }
        }
        return false
    }
    
}


