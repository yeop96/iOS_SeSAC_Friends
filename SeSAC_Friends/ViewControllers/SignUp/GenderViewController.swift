//
//  GenderViewController.swift
//  SeSAC_Friends
//
//  Created by yeop on 2022/01/24.
//

import UIKit
import SnapKit
import Toast
import Alamofire
import JGProgressHUD

class GenderViewController: BaseViewController {
    
    let textLabel = UILabel()
    let explainLabel = UILabel()
    let stackView = UIStackView()
    let maleButton = ImageButton()
    let femaleButton = ImageButton()
    let nextButton = DisableButton()
    let nextButtonActive = FillButton()
    var selectNumber = GenderNumber.unSelect.rawValue
    let progress = JGProgressHUD()
    var nickNameBackBool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if nickNameBackBool{
            if UserData.gender == GenderNumber.male.rawValue{
                maleButton.clicked()
            } else if UserData.gender == GenderNumber.female.rawValue{
                femaleButton.clicked()
            }
            selectNumber = UserData.gender
            buttonActive()
        }
    }

    override func configure() {
        backConfigure()
        
        textLabel.text = "성별을 선택해 주세요"
        textLabel.font = UIFont().Display1_R20
        textLabel.textColor = .black
        textLabel.textAlignment = .center
        
        explainLabel.text = "새싹 찾기 기능을 이용하기 위해서 필요해요!"
        explainLabel.font = UIFont().Title2_R16
        explainLabel.textColor = .gray7
        explainLabel.textAlignment = .center
        
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.spacing = 12
        
        maleButton.imageView.image = UIImage(named: "man")
        maleButton.label.text = "남자"
        femaleButton.imageView.image = UIImage(named: "woman")
        femaleButton.label.text = "여자"
        let maleTapGesture = UITapGestureRecognizer(target: self, action: #selector(maleButtonHandleTap(sender:)))
        let femaleTapGesture = UITapGestureRecognizer(target: self, action: #selector(femaleButtonHandleTap(sender:)))
        let viewTapGesture = UITapGestureRecognizer(target: self, action: #selector(viewHandleTap(sender:)))
        maleButton.addGestureRecognizer(maleTapGesture)
        femaleButton.addGestureRecognizer(femaleTapGesture)
        view.addGestureRecognizer(viewTapGesture)
        
        
        nextButton.setTitle("다음", for: .normal)
        nextButton.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)
        nextButtonActive.setTitle("다음", for: .normal)
        nextButtonActive.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)
        
        nextButtonActive.isHidden = true
    }
    
    override func setupConstraints() {
        view.addSubview(textLabel)
        view.addSubview(explainLabel)
        view.addSubview(stackView)
        stackView.addArrangedSubview(maleButton)
        stackView.addArrangedSubview(femaleButton)
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
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(explainLabel.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(120)
        }
        
        maleButton.snp.makeConstraints { make in
            make.height.equalTo(120)
        }
        femaleButton.snp.makeConstraints { make in
            make.height.equalTo(120)
        }
        
        nextButton.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(72)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }
        
        nextButtonActive.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(72)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }
    }
    
    @objc func maleButtonHandleTap(sender: UITapGestureRecognizer) {
        if selectNumber == GenderNumber.male.rawValue{
            maleButton.unclicked()
            selectNumber = GenderNumber.unSelect.rawValue
        } else{
            maleButton.clicked()
            femaleButton.unclicked()
            selectNumber = GenderNumber.male.rawValue
        }
        buttonActive()
    }
    @objc func femaleButtonHandleTap(sender: UITapGestureRecognizer) {
        if selectNumber == GenderNumber.female.rawValue{
            femaleButton.unclicked()
            selectNumber = GenderNumber.unSelect.rawValue
        } else{
            femaleButton.clicked()
            maleButton.unclicked()
            selectNumber = GenderNumber.female.rawValue
        }
        buttonActive()
    }
    @objc func viewHandleTap(sender: UITapGestureRecognizer) {
        selectNumber = GenderNumber.unSelect.rawValue
        maleButton.unclicked()
        femaleButton.unclicked()
        buttonActive()
    }
    
    
    @objc func nextButtonClicked(){
        UserData.gender = selectNumber
        userSignUp()
    }
    
    func buttonActive(){
        if selectNumber == GenderNumber.unSelect.rawValue{
            nextButton.isHidden = false
            nextButtonActive.isHidden = true
        } else{
            nextButton.isHidden = true
            nextButtonActive.isHidden = false
        }
    }
    
    func userSignUp() {
        progress.show(in: view, animated: true)
        ServerService.shared.postSignUp{ statusCode, json in
            switch statusCode{
            case ServerStatusCode.OK.rawValue:
                AppFirstLaunch.isAppLogin = true
                print("회원가입 성공")
                DispatchQueue.main.async {
                    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
                    windowScene.windows.first?.rootViewController = TabBarController()
                    windowScene.windows.first?.makeKeyAndVisible()
                }
            case SignupStatusCode.CANT_USE_NICKNAME.rawValue:
                print("사용할 수 없는 닉네임(ex. 바람의나라, 미묘한도사, 고래밥)")
                self.backNavigationControllers()
            case ServerStatusCode.FIREBASE_TOKEN_ERROR.rawValue:
                ServerService.updateIdToken { result in
                    switch result {
                    case .success:
                        self.userSignUp()
                    case .failure(let error):
                        print(error.localizedDescription)
                        return
                    }
                }
                
            default:
                print("ERROR?: ", statusCode, json)
                DispatchQueue.main.async {
                    self.view.makeToast("에러가 발생했습니다. 잠시 후 다시 시도해주세요.", duration: 3.0, position: .top)
                }
            }
        }
        self.progress.dismiss(animated: true)
    }
    
    
    func backNavigationControllers(){
        
        guard let presentingVC = self.navigationController else { return }
        let viewControllerStack = presentingVC.viewControllers
      
        for viewController in viewControllerStack {
            //navigation stack 에서 NickNameViewController(돌아가고싶은 뷰)가 있다면 거기까지 pop.
            if let rootVC = viewController as? NickNameViewController {
                rootVC.nickNameBackBool = true
                presentingVC.popToViewController(rootVC, animated: true)
            }
        }
    }
    
}

