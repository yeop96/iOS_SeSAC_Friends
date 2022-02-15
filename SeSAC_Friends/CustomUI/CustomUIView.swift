//
//  CustomUIView.swift
//  SeSAC_Friends
//
//  Created by yeop on 2022/02/15.
//

import UIKit
import SnapKit

class EmptyUIView: UIView {
    let sproutImageView = UIImageView()
    let emptyLabel = UILabel()
    let emptyDescriptionLabel = UILabel()
    let changeHobbyButton = FillButton()
    let reloadButton = ReloadButton()
    
    convenience init(text: String) {
        self.init(frame: .zero)
        
        emptyLabel.text = text
        configure()
        setupConstraints()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        sproutImageView.image = UIImage(named: "img_gray")
        emptyLabel.font = UIFont().Display1_R20
        emptyLabel.textColor = .black
        emptyDescriptionLabel.text = "취미를 변경하거나 조금만 더 기다려 주세요!"
        emptyDescriptionLabel.font = UIFont().Title4_R14
        emptyDescriptionLabel.textColor = .gray7
        changeHobbyButton.setTitle("취미 변경하기", for: .normal)
        changeHobbyButton.addTarget(self, action: #selector(changeHobbyButtonClicked), for: .touchUpInside)
    }
    
    func setupConstraints() {
        addSubview(emptyLabel)
        addSubview(sproutImageView)
        addSubview(emptyDescriptionLabel)
        addSubview(reloadButton)
        addSubview(changeHobbyButton)
        
        emptyLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(32)
        }
        sproutImageView.snp.makeConstraints { make in
            make.bottom.equalTo(emptyLabel.snp.top).offset(-32)
            make.centerX.equalToSuperview()
            make.size.equalTo(64)
        }
        emptyDescriptionLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(emptyLabel.snp.bottom).offset(8)
            make.height.equalTo(22)
        }
        
        reloadButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(self.safeAreaLayoutGuide).inset(16)
        }
        changeHobbyButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.trailing.equalTo(reloadButton.snp.leading).offset(-8)
            make.bottom.equalTo(self.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(48)
        }
    }
    
    @objc func changeHobbyButtonClicked(){
        
    }
}

class ReputationButtonsView: UIView {
    
    let verticalStackView = UIStackView()
    let firstHorizontalStackView = UIStackView()
    let secondHorizontalStackView = UIStackView()
    let thirdHorizontalStackView = UIStackView()
    let mannerButton = InactiveButton()
    let timeButton = InactiveButton()
    let fastButton = InactiveButton()
    let kindButton = InactiveButton()
    let handyButton = InactiveButton()
    let beneficialButton = InactiveButton()
    let reputations = ["좋은 매너", "정확한 시간 약속", "빠른 응답", "친절한 성격", "능숙한 취미 실력", "유익한 시간"]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        verticalStackView.axis = .vertical
        firstHorizontalStackView.axis = .horizontal
        secondHorizontalStackView.axis = .horizontal
        thirdHorizontalStackView.axis = .horizontal
        [verticalStackView, firstHorizontalStackView, secondHorizontalStackView, thirdHorizontalStackView].forEach {
            $0.spacing = 8
            $0.distribution = .fillEqually
        }
        for (index, button) in [mannerButton, timeButton, fastButton, kindButton, handyButton, beneficialButton].enumerated() {
            button.setTitle(reputations[index], for: .normal)
        }
    }
    
    func setupConstraints() {
        addSubview(verticalStackView)
        verticalStackView.addArrangedSubview(firstHorizontalStackView)
        verticalStackView.addArrangedSubview(secondHorizontalStackView)
        verticalStackView.addArrangedSubview(thirdHorizontalStackView)
        firstHorizontalStackView.addArrangedSubview(mannerButton)
        firstHorizontalStackView.addArrangedSubview(timeButton)
        secondHorizontalStackView.addArrangedSubview(fastButton)
        secondHorizontalStackView.addArrangedSubview(kindButton)
        thirdHorizontalStackView.addArrangedSubview(handyButton)
        thirdHorizontalStackView.addArrangedSubview(beneficialButton)
        
        verticalStackView.addArrangedSubview(firstHorizontalStackView)
        verticalStackView.addArrangedSubview(secondHorizontalStackView)
        verticalStackView.addArrangedSubview(thirdHorizontalStackView)
        
        self.snp.makeConstraints { make in
            make.height.equalTo(112)
        }
        
        verticalStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        [firstHorizontalStackView, secondHorizontalStackView, thirdHorizontalStackView, mannerButton, timeButton, fastButton, kindButton, handyButton, beneficialButton].forEach {
            $0.snp.makeConstraints { make in
                make.height.equalTo(32)
            }
        }
    }
    
}
