//
//  MessageAuthViewController.swift
//  SeSAC_Friends
//
//  Created by yeop on 2022/01/21.
//

import UIKit
import SnapKit
import Toast

class MessageAuthViewController: BaseViewController {
    
    var limitTime = 300

    let textLabel = UILabel()
    let subTextLabel = UILabel()
    let authTextField = InputTextField()
    let timerLabel = UILabel()
    let startButton = DisableButton()
    let startButtonActive = FillButton()
    let reSendButton = FillButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authTextField.delegate = self
        
        let windows = UIApplication.shared.windows
        windows.last?.makeToast("인증번호를 보냈습니다.", duration: 1.0, position: .top)
    }

    override func configure() {
        view.backgroundColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "arrow"), style: .plain, target: self, action: #selector(backButtonClicked))
        self.navigationController?.navigationBar.tintColor = .black
        
        textLabel.text = "인증번호가 문자로 전송되었어요"
        textLabel.font = UIFont().Display1_R20
        textLabel.textColor = .black
        textLabel.textAlignment = .center
        
        subTextLabel.text = "최대 소모 20초"
        subTextLabel.font = UIFont().Title2_R16
        subTextLabel.textColor = .gray7
        subTextLabel.textAlignment = .center
        
        
        authTextField.placeholder = "인증번호 입력"
        authTextField.keyboardType = .numberPad
        authTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        timerLabel.text = ""
        timerLabel.font = UIFont().Title3_M14
        timerLabel.textColor = .green
        timerLabel.textAlignment = .center
        getSetTime()
        
        startButton.setTitle("인증하고 시작하기", for: .normal)
        startButtonActive.setTitle("인증하고 시작하기", for: .normal)
        startButtonActive.isHidden = true
        
        reSendButton.setTitle("재전송", for: .normal)
    }
    
    override func setupConstraints() {
        view.addSubview(textLabel)
        view.addSubview(subTextLabel)
        view.addSubview(authTextField)
        authTextField.addSubview(timerLabel)
        view.addSubview(reSendButton)
        view.addSubview(startButton)
        view.addSubview(startButtonActive)
        
        textLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(125)
            make.centerX.equalToSuperview()
        }
        
        subTextLabel.snp.makeConstraints { make in
            make.top.equalTo(textLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
        
        authTextField.snp.makeConstraints { make in
            make.top.equalTo(subTextLabel.snp.bottom).offset(76)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-96)
            make.height.equalTo(48)
        }
        
        timerLabel.snp.makeConstraints { make in
            make.centerY.equalTo(authTextField.textHeight()-8)
            make.trailing.equalToSuperview().offset(-12)
        }
        
        reSendButton.snp.makeConstraints { make in
            make.top.equalTo(subTextLabel.snp.bottom).offset(69)
            make.trailing.equalToSuperview().offset(-16)
            make.width.equalTo(72)
            make.height.equalTo(40)
        }
        
        startButton.snp.makeConstraints { make in
            make.top.equalTo(authTextField.snp.bottom).offset(72)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }
        
        startButtonActive.snp.makeConstraints { make in
            make.top.equalTo(authTextField.snp.bottom).offset(72)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }
    }
    
    func secToTime(sec: Int) {
        let minute = (sec % 3600) / 60
        let second = (sec % 3600) % 60
        
        if second < 10{
            timerLabel.text = String(minute) + ":" + "0" + String(second)
        } else{
            timerLabel.text = String(minute) + ":" + String(second)
        }
        
        if limitTime != 0 {
            perform(#selector(getSetTime), with: nil, afterDelay: 1.0)
        } else if limitTime == 0{
            timerLabel.isHidden = true
        }
    }
    
    @objc func getSetTime(){
        secToTime(sec: limitTime)
        limitTime -= 1
    }
    
    @objc func backButtonClicked(){
        self.navigationController?.popViewController(animated: true)
    }
}


extension MessageAuthViewController: UITextFieldDelegate{
    @objc func textFieldDidChange(_ textField: UITextField) {
        if let text = textField.text {
            if !text.allSatisfy({$0.isNumber}) {
                authTextField.errorColor = .error
                authTextField.errorMessage = "숫자만 입력"
                startButton.isHidden = false
                startButtonActive.isHidden = true
            } else if text.count >= 6{
                authTextField.errorColor = .success
                authTextField.errorMessage = "인증하기"
                startButton.isHidden = true
                startButtonActive.isHidden = false
            } else{
                authTextField.errorMessage = ""
                startButton.isHidden = false
                startButtonActive.isHidden = true
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        return newLength <= 7 // 숫자제한
    }
}
