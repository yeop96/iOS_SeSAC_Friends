//
//  MyInformationManagementViewController.swift
//  SeSAC_Friends
//
//  Created by yeop on 2022/02/02.
//

import UIKit
import SnapKit
import MultiSlider
import JGProgressHUD

final class MyInformationManagementViewController: BaseViewController {
    
    let progress = JGProgressHUD()
    let scrollView = UIScrollView()
    let contentView = UIView()
    let profileView = UIView()
    let profileBackImageView = UIImageView()
    let profileUserImageView = UIImageView()
    let nameView = UIView()
    let nameLabel = UILabel()
    
    let settingStackView = UIStackView()
    
    let genderStackView = UIStackView()
    let genderLabel = UILabel()
    let maleButton = InactiveButton()
    let femaleButton = InactiveButton()
    
    let hobbyStackView = UIStackView()
    let hobbyLabel = UILabel()
    let hobbyTextField = InputTextField()
    
    let phoneAccessStackView = UIStackView()
    let phoneAccessLabel = UILabel()
    let phoneAccessButton = ToggleButton()
    
    let matchAgeStackView = UIStackView()
    let matchAgeTextLabel = UILabel()
    let matchAgeLabel = UILabel()
    let matchAgeSlider = MultiSlider()
    
    let withdrawButton = UILabel()
    
    var selectSearchable = UserData.searchable
    var selectAgeMin = UserData.ageMin
    var selectAgeMax = UserData.ageMax
    var selectGender = UserData.gender
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userCheck()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func configure() {
        title = "정보 관리"
        backConfigure()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(saveButtonClicked))
        navigationItem.rightBarButtonItem?.setTitleTextAttributes([.foregroundColor: UIColor.black, .font: UIFont().Title3_M14], for: .normal)
        
        scrollView.backgroundColor = .white
        scrollView.showsVerticalScrollIndicator = true
        
        settingStackView.axis = .vertical
        settingStackView.spacing = 16
        settingStackView.distribution = .fill
        [genderStackView, hobbyStackView, phoneAccessStackView, matchAgeStackView].forEach {
            $0.axis = .horizontal
            $0.spacing = 8
            $0.distribution = .fill
        }
        profileView.layer.cornerRadius = 8
        profileView.clipsToBounds = true
        profileBackImageView.image = SesacBackgroundImage(rawValue: UserData.background)?.sesacBackgroundUIImage()
        profileUserImageView.image = SesacImage(rawValue: UserData.sesac)?.sesacUIImage()
        nameView.layer.cornerRadius = 8
        nameView.layer.borderWidth = 1
        nameView.layer.borderColor = UIColor.gray2.cgColor
        nameLabel.text = UserData.nickName
        nameLabel.font = UIFont().Title1_M16
        nameLabel.textColor = .black
        
        genderLabel.text = "내 성별"
        hobbyLabel.text = "자주 하는 취미"
        phoneAccessLabel.text = "내 번호 검색 허용"
        matchAgeTextLabel.text = "상대방 연령대"
        withdrawButton.text = "회원탈퇴"
        [genderLabel, hobbyLabel, phoneAccessLabel, matchAgeTextLabel, withdrawButton].forEach {
            $0.textAlignment = .left
            $0.font = UIFont().Title4_R14
        }
        maleButton.setTitle("남자", for: .normal)
        femaleButton.setTitle("여자", for: .normal)
        
        if UserData.gender == GenderNumber.male.rawValue{
            maleButton.clicked()
            selectGender = GenderNumber.male.rawValue
        } else if UserData.gender == GenderNumber.female.rawValue{
            femaleButton.clicked()
            selectGender = GenderNumber.female.rawValue
        } else{
            selectGender = GenderNumber.unSelect.rawValue
        }
        maleButton.addTarget(self, action: #selector(maleButtonClicked), for: .touchUpInside)
        femaleButton.addTarget(self, action: #selector(femaleButtonClicked), for: .touchUpInside)
        
        hobbyTextField.placeholder = "취미를 입력해 주세요"
        hobbyTextField.text = UserData.hobby
        
        if UserData.searchable == 1{
            phoneAccessButton.toggleOn()
            selectSearchable = 1
        } else{
            phoneAccessButton.toggleOff()
            selectSearchable = 0
        }
        let toggle = UITapGestureRecognizer(target: self, action: #selector(phoneAccessButtonClicked))
        phoneAccessButton.isUserInteractionEnabled = true
        phoneAccessButton.addGestureRecognizer(toggle)
        
        matchAgeLabel.text = "\(UserData.ageMin) - \(UserData.ageMax)"
        matchAgeLabel.textAlignment = .right
        matchAgeLabel.font = UIFont().Title3_M14
        matchAgeLabel.textColor = .green
        
        matchAgeSlider.minimumValue = 18
        matchAgeSlider.maximumValue = 65
        matchAgeSlider.orientation = .horizontal
        matchAgeSlider.outerTrackColor = .gray2
        matchAgeSlider.tintColor = .green
        matchAgeSlider.value = [CGFloat(UserData.ageMin), CGFloat(UserData.ageMax)]
        matchAgeSlider.thumbImage = UIImage(named: "filter_control")
        matchAgeSlider.showsThumbImageShadow = false
        matchAgeSlider.hasRoundTrackEnds = true
        matchAgeSlider.trackWidth = 4
        matchAgeSlider.addTarget(self, action: #selector(sliderChanged), for: .valueChanged) // continuous changes
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(withdrawButtonClicked))
        withdrawButton.isUserInteractionEnabled = true
        withdrawButton.addGestureRecognizer(tap)
    }
    
    override func setupConstraints() {
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.width.equalTo(view.snp.width)
            make.bottom.equalToSuperview().inset(20)
        }
        
        [profileView, nameView, settingStackView, matchAgeSlider, withdrawButton].forEach {
            contentView.addSubview($0)
        }
        [genderStackView, hobbyStackView, phoneAccessStackView, matchAgeStackView].forEach {
            settingStackView.addArrangedSubview($0)
            $0.snp.makeConstraints { make in
                make.height.equalTo(48)
            }
        }
        
        profileView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(194)
        }
        profileView.addSubview(profileBackImageView)
        profileView.addSubview(profileUserImageView)
        profileBackImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        profileUserImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(19)
            make.height.width.equalTo(184)
        }
        nameView.snp.makeConstraints { make in
            make.top.equalTo(profileView.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(58)
        }
        nameView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
        
        settingStackView.snp.makeConstraints { make in
            make.top.equalTo(nameView.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        genderStackView.addArrangedSubview(genderLabel)
        genderStackView.addArrangedSubview(maleButton)
        genderStackView.addArrangedSubview(femaleButton)
        maleButton.snp.makeConstraints { make in
            make.height.equalTo(48)
            make.width.equalTo(56)
        }
        femaleButton.snp.makeConstraints { make in
            make.height.equalTo(48)
            make.width.equalTo(56)
        }
        
        hobbyStackView.addArrangedSubview(hobbyLabel)
        hobbyStackView.addArrangedSubview(hobbyTextField)
        hobbyTextField.snp.makeConstraints { make in
            make.width.equalTo(164)
        }
        
        phoneAccessStackView.addArrangedSubview(phoneAccessLabel)
        phoneAccessStackView.addArrangedSubview(phoneAccessButton)
        phoneAccessButton.snp.makeConstraints { make in
            //make.height.equalTo(28)
            make.width.equalTo(52)
        }
        
        matchAgeStackView.addArrangedSubview(matchAgeTextLabel)
        matchAgeStackView.addArrangedSubview(matchAgeLabel)
        
        matchAgeSlider.snp.makeConstraints { make in
            make.top.equalTo(settingStackView.snp.bottom).offset(1)
            make.leading.trailing.equalToSuperview().inset(17)
        }
        
        withdrawButton.snp.makeConstraints { make in
            make.top.equalTo(matchAgeSlider.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(48)
            make.bottom.equalToSuperview().inset(16)
        }
    }
    @objc func maleButtonClicked(){
        if selectGender == GenderNumber.female.rawValue{
            femaleButton.unclicked()
            maleButton.clicked()
            selectGender = GenderNumber.male.rawValue
        }
    }
    @objc func femaleButtonClicked(){
        if selectGender == GenderNumber.male.rawValue{
            maleButton.unclicked()
            femaleButton.clicked()
            selectGender = GenderNumber.female.rawValue
        }
    }
    @objc func phoneAccessButtonClicked(sender: UITapGestureRecognizer){
        if selectSearchable == 1{
            phoneAccessButton.toggleOff()
            selectSearchable = 0
        } else{
            phoneAccessButton.toggleOn()
            selectSearchable = 1
        }
    }
    @objc func sliderChanged(_ slider: MultiSlider) {
        matchAgeLabel.text = "\(Int(slider.value[0])) - \(Int(slider.value[1]))"
        selectAgeMin = Int(slider.value[0])
        selectAgeMax = Int(slider.value[1])
    }
    
    
    
    //회원탈퇴
    @objc func withdrawButtonClicked(sender: UITapGestureRecognizer) {
        let popUpViewController = PopUpViewController(titleText: "정말 탈퇴하시겠습니까?", messageText: "탈퇴하시면 새싹 프렌즈를 이용할 수 없어요ㅠ")
        popUpViewController.confirmAction = {
            self.userWithdraw()
        }
        present(popUpViewController, animated: false, completion: nil)
    }
    
    //저장버튼
    @objc func saveButtonClicked(){
        progress.show(in: view, animated: true)
        UserData.searchable = selectSearchable
        UserData.ageMin = selectAgeMin
        UserData.ageMax = selectAgeMax
        UserData.gender = selectGender
        UserData.hobby = hobbyTextField.text ?? ""
        
        ServerService.shared.postMyPage { statusCode, json in
            switch statusCode{
            case ServerStatusCode.OK.rawValue:
                print("저장완료")
            case ServerStatusCode.FIREBASE_TOKEN_ERROR.rawValue:
                ServerService.updateIdToken { result in
                    switch result {
                    case .success:
                        self.saveButtonClicked()
                    case .failure(let error):
                        print(error.localizedDescription)
                        return
                    }
                }
            default:
                print("ERROR: ", statusCode, json)
            }
        }
        self.progress.dismiss(animated: true)
        
    }
    
    //회원 정보 가져오기
    func userCheck() {
        progress.show(in: view, animated: true)
        ServerService.shared.getUserInfo { statusCode, json in
            switch statusCode{
            case ServerStatusCode.OK.rawValue:
                DispatchQueue.main.async {
                    UserData.background = json["background"].intValue
                    UserData.sesac = json["sesac"].intValue
                    UserData.nickName =  json["nick"].stringValue
                    UserData.gender = json["gender"].intValue
                    UserData.hobby = json["hobby"].stringValue
                    UserData.searchable = json["searchable"].intValue
                    UserData.ageMin = json["ageMin"].intValue
                    UserData.ageMax = json["ageMax"].intValue
                    UserData.myUID = json["uid"].stringValue
                }
            case ServerStatusCode.FIREBASE_TOKEN_ERROR.rawValue:
                ServerService.updateIdToken { result in
                    switch result {
                    case .success:
                        print("idToken 업데이트..!")
                        self.userCheck()
                    case .failure(let error):
                        print(error.localizedDescription)
                        return
                    }
                }
            default:
                print("ERROR: ", statusCode, json)
            }
        }
        self.progress.dismiss(animated: true)
        
    }
    
    //회원 탈퇴
    func userWithdraw(){
        progress.show(in: view, animated: true)
        ServerService.shared.postWithdraw{ statusCode, json in
            switch statusCode{
            case ServerStatusCode.OK.rawValue:
                DispatchQueue.main.async {
                    AppFirstLaunch.isAppLogin = false
                    UserData.idToken = ""
                    UserData.phoneNumber = ""
                    UserData.fcmToken = ""
                    UserData.nickName = ""
                    UserData.birth = Date()
                    UserData.email = ""
                    UserData.gender = GenderNumber.unSelect.rawValue
                    UserData.background = 0
                    UserData.sesac = 0
                    UserData.hobby = ""
                    UserData.searchable = 1
                    UserData.ageMin = 18
                    UserData.ageMax = 38
                    UserData.lat = 0.0
                    UserData.long = 0.0
                    UserData.region = 0
                    UserData.matchingStatus = MatchingStatus.search.rawValue
                    UserData.myUID = ""
                    UserData.matchedUID = ""
                    UserData.matchedNick = ""
                    
                    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
                    windowScene.windows.first?.rootViewController = UINavigationController(rootViewController: PhoneAuthViewController())
                    windowScene.windows.first?.makeKeyAndVisible()
                }
            case ServerStatusCode.FIREBASE_TOKEN_ERROR.rawValue:
                ServerService.updateIdToken { result in
                    switch result {
                    case .success:
                        self.userWithdraw()
                    case .failure(let error):
                        print(error.localizedDescription)
                        return
                    }
                }
            default:
                print("ERROR: ", statusCode, json)
            }
        }
        self.progress.dismiss(animated: true)
    }
}
