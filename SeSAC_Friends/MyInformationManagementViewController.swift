//
//  MyInformationManagementViewController.swift
//  SeSAC_Friends
//
//  Created by yeop on 2022/02/02.
//

import UIKit
import SnapKit

class MyInformationManagementViewController: BaseViewController {
    
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
    let matchAgeSlider = UILabel()
    
    let withdrawButton = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func configure() {
        title = "정보 관리"
        backConfigure()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(saveButtonClicked))
        navigationItem.rightBarButtonItem?.setTitleTextAttributes([.foregroundColor: UIColor.black, .font: UIFont().Title3_M14], for: .normal)
        
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
        profileBackImageView.image = UIImage(named: "sesac_background_1")
        profileUserImageView.image = UIImage(named: "sesac_face_1")
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
        
        hobbyTextField.placeholder = "취미를 입력해 주세요"
        
        matchAgeLabel.text = "18 - 35"
        matchAgeLabel.textAlignment = .right
        matchAgeLabel.font = UIFont().Title3_M14
        matchAgeLabel.textColor = .green
    }
    
    override func setupConstraints() {
        
        [profileView, nameView, settingStackView, withdrawButton].forEach {
            view.addSubview($0)
        }
        [genderStackView, hobbyStackView, phoneAccessStackView, matchAgeStackView].forEach {
            settingStackView.addArrangedSubview($0)
        }
        
        profileView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(16)
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
            make.width.equalTo(52)
        }
        
        matchAgeStackView.addArrangedSubview(matchAgeTextLabel)
        matchAgeStackView.addArrangedSubview(matchAgeLabel)
        
        withdrawButton.snp.makeConstraints { make in
            make.top.equalTo(profileView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }
    
    @objc func saveButtonClicked(){
    }
}
