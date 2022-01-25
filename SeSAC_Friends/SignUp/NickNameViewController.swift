//
//  NickNameViewController.swift
//  SeSAC_Friends
//
//  Created by yeop on 2022/01/23.
//

import UIKit
import SnapKit
import Toast

class NickNameViewController: BaseViewController {
    
    let textLabel = UILabel()
    let nickNameTextField = InputTextField()
    let nextButton = DisableButton()
    let nextButtonActive = FillButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func configure() {
        view.backgroundColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "arrow"), style: .plain, target: self, action: #selector(backButtonClicked))
        self.navigationController?.navigationBar.tintColor = .black
        
        textLabel.text = "닉네임을 입력해 주세요"
        textLabel.font = UIFont().Display1_R20
        textLabel.textColor = .black
        textLabel.textAlignment = .center
        
        nickNameTextField.delegate = self
        nickNameTextField.placeholder = "10자 이내로 입력"
        nickNameTextField.keyboardType = .default
        nickNameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        nickNameTextField.becomeFirstResponder()
        
        nextButton.setTitle("다음", for: .normal)
        nextButton.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)
        nextButtonActive.setTitle("다음", for: .normal)
        nextButtonActive.addTarget(self, action: #selector(nextButtonActiveClicked), for: .touchUpInside)
        
        nextButtonActive.isHidden = true
    }
    
    override func setupConstraints() {
        view.addSubview(textLabel)
        view.addSubview(nickNameTextField)
        view.addSubview(nextButton)
        view.addSubview(nextButtonActive)
        
        textLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(125)
            make.centerX.equalToSuperview()
        }
        
        nickNameTextField.snp.makeConstraints { make in
            make.top.equalTo(textLabel.snp.bottom).offset(80)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }
        
        nextButton.snp.makeConstraints { make in
            make.top.equalTo(nickNameTextField.snp.bottom).offset(72)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }
        
        nextButtonActive.snp.makeConstraints { make in
            make.top.equalTo(nickNameTextField.snp.bottom).offset(72)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }
        
    }
    @objc func nextButtonClicked(){
        windows.last?.makeToast("닉네임은 1자 이상 10자 이내로 부탁드려요", duration: 3.0, position: .top)
    }
    
    @objc func nextButtonActiveClicked(){
        guard let nickName = nickNameTextField.text else { return }
        UserData.nickName = nickName
        
        let vc = BirthViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension NickNameViewController: UITextFieldDelegate{
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if let text = textField.text {
            if !Exception.IsValidNickName(nickName: text) {
                nickNameTextField.errorColor = .error
                nickNameTextField.errorMessage = "공백을 제외한 10자이내 문자로 입력"
                nextButton.isHidden = false
                nextButtonActive.isHidden = true
            } else{
                nickNameTextField.errorColor = .success
                nickNameTextField.errorMessage = "다음"
                nextButton.isHidden = true
                nextButtonActive.isHidden = false
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        return newLength <= 10 // 숫자제한
    }
    
}



