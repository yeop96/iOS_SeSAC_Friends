//
//  EmailViewController.swift
//  SeSAC_Friends
//
//  Created by yeop on 2022/01/24.
//

import UIKit
import SnapKit
import Toast

class EmailViewController: BaseViewController {
    
    let textLabel = UILabel()
    let explainLabel = UILabel()
    let emailTextField = InputTextField()
    let nextButton = DisableButton()
    let nextButtonActive = FillButton()
    var nickNameBackBool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if nickNameBackBool{
            emailTextField.text = UserData.email
            emailTextField.errorColor = .success
            emailTextField.errorMessage = "다음"
            nextButton.isHidden = true
            nextButtonActive.isHidden = false
        }
    }

    override func configure() {
        backConfigure()
        
        textLabel.text = "이메일을 입력해 주세요"
        textLabel.font = UIFont().Display1_R20
        textLabel.textColor = .black
        textLabel.textAlignment = .center
        
        explainLabel.text = "휴대폰 번호 변경 시 인증을 위해 사용해요"
        explainLabel.font = UIFont().Title2_R16
        explainLabel.textColor = .gray7
        explainLabel.textAlignment = .center
        
        emailTextField.delegate = self
        emailTextField.placeholder = "yeop96@email.com"
        emailTextField.keyboardType = .emailAddress
        emailTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        emailTextField.becomeFirstResponder()
        
        nextButton.setTitle("다음", for: .normal)
        nextButton.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)
        nextButtonActive.setTitle("다음", for: .normal)
        nextButtonActive.addTarget(self, action: #selector(nextButtonActiveClicked), for: .touchUpInside)
        
        nextButtonActive.isHidden = true
    }
    
    override func setupConstraints() {
        view.addSubview(textLabel)
        view.addSubview(explainLabel)
        view.addSubview(emailTextField)
        view.addSubview(nextButton)
        view.addSubview(nextButtonActive)
        
        textLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(125-16)
            make.centerX.equalToSuperview()
        }
        
        explainLabel.snp.makeConstraints { make in
            make.top.equalTo(textLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(explainLabel.snp.bottom).offset(63)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }
        
        nextButton.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(72)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }
        
        nextButtonActive.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(72)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }
        
    }
    @objc func nextButtonClicked(){
        self.view.makeToast("이메일 형식이 올바르지 않습니다.", duration: 3.0, position: .top)
    }
    
    @objc func nextButtonActiveClicked(){
        guard let email = emailTextField.text else { return }
        UserData.email = email
        
        let vc = GenderViewController()
        vc.nickNameBackBool = nickNameBackBool ? true : false
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension EmailViewController: UITextFieldDelegate{
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if let text = textField.text {
            if !Exception.IsValidEmail(email: text) {
                emailTextField.errorColor = .error
                emailTextField.errorMessage = "이메일 형식을 맞춰주세요."
                nextButton.isHidden = false
                nextButtonActive.isHidden = true
            }  else{
                emailTextField.errorColor = .success
                emailTextField.errorMessage = "다음"
                nextButton.isHidden = true
                nextButtonActive.isHidden = false
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        return newLength <= 30
    }
    
}
