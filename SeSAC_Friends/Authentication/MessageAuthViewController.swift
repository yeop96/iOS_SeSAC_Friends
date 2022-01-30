//
//  MessageAuthViewController.swift
//  SeSAC_Friends
//
//  Created by yeop on 2022/01/21.
//

import UIKit
import SnapKit
import Toast
import Firebase
import FirebaseAuth
import Alamofire
import JGProgressHUD

class MessageAuthViewController: BaseViewController {
    
    let progress = JGProgressHUD()
    var limitTime = 60
    var verificationID = ""
    var phoneNumber = ""
    var credential: PhoneAuthCredential?

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
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        windows.last?.makeToast("인증번호를 보냈습니다.", duration: 5.0, position: .top)
        
    }

    override func configure() {
        backConfigure()
        
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
        authTextField.becomeFirstResponder()
        authTextField.textContentType = .oneTimeCode //SMS 인증 번호 자동 추천
        authTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        timerLabel.text = ""
        timerLabel.font = UIFont().Title3_M14
        timerLabel.textColor = .green
        timerLabel.textAlignment = .center
        getSetTime()
        
        startButton.setTitle("인증하고 시작하기", for: .normal)
        startButtonActive.setTitle("인증하고 시작하기", for: .normal)
        startButtonActive.isHidden = true
        
        startButton.addTarget(self, action: #selector(startButtonClicked), for: .touchUpInside)
        startButtonActive.addTarget(self, action: #selector(startButtonActiveClicked), for: .touchUpInside)
        
        reSendButton.setTitle("재전송", for: .normal)
        reSendButton.addTarget(self, action: #selector(reSendButtonClicked), for: .touchUpInside)
        
        
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
    
    @objc func startButtonClicked(){
        self.view.makeToast("인증번호를 입력해주세요.", duration: 1.0, position: .top)
    }
    
    @objc func startButtonActiveClicked(){
        
        guard let verificationCode = authTextField.text else { return }
        
        credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID,
            verificationCode: verificationCode
        )
        
        Auth.auth().signIn(with: credential!) { authResult, error in
            if let error = error {
                print("에러짱 :", error)
                self.view.makeToast("전화번호 인증 실패", duration: 3.0, position: .top)
            }
            // 인증 완료 -> 파이어베이스 아이디 토큰 요청
            print("authData :", authResult ?? "")
            
            let currentUser = Auth.auth().currentUser
            currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
                if let error = error {
                    print("에러짱 :", error)
                    self.view.makeToast("에러가 발생했습니다. 잠시 후 다시 시도해주세요.", duration: 3.0, position: .top)
                    return
                }
                //아이디 토큰 받기 성공 -> 서버로부터 사용자 정보 확인
                UserData.idToken = idToken ?? ""
                print("아이디 토큰",idToken)
                self.userCheck()
            }
        }
        
    }
    
    func userCheck() {
        progress.show(in: view, animated: true)
        DispatchQueue.global().async {
            ServerService.shared.getUserInfo { statusCode, json in
                switch statusCode{
                case 200:
                    print("로그인 성공", "홈 화면으로 이동")
                    DispatchQueue.main.async {
                        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
                        windowScene.windows.first?.rootViewController = TabBarController()
                        windowScene.windows.first?.makeKeyAndVisible()
                    }
                case 201:
                    print("미가입 유저","회원가입 화면으로 이동")
                    DispatchQueue.main.async {
                        let vc = NickNameViewController()
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                default:
                    print("ERROR: ", statusCode, json)
                }
            }
            self.progress.dismiss(animated: true)
        }
        print("fetchEnd")
    }
    
    
    @objc func reSendButtonClicked(){
        PhoneAuthProvider.provider()
            .verifyPhoneNumber("+82" + phoneNumber, uiDelegate: nil) { verificationID, error in
                if let error = error {
                    print("에러 :", error.localizedDescription)
                    self.view.makeToast("에러가 발생했습니다. 다시 시도해주세요.", duration: 3.0, position: .top)
                    return
                }
                self.verificationID = verificationID ?? ""
                self.view.makeToast("인증 번호 재전송", duration: 3.0, position: .top)
                self.limitTime = 60
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
        if limitTime == limitTime - 60{
            self.view.makeToast("전화번호 인증 실패 (60초 초과)", duration: 3.0, position: .top)
        }
        limitTime -= 1
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
            } else if text.count == 6{
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
        return newLength <= 6 // 숫자제한
    }
}
