//
//  CustomAlert.swift
//  SeSAC_Friends
//
//  Created by yeop on 2022/02/06.
//

import UIKit

class SesacAlert: UIView{
    let titleLabel = UILabel()
    let descriptionLabel = UILabel()
    let cancelButton = CancelButton()
    let confirmButton = FillButton()
    let stackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = 16
        self.backgroundColor = .white
        self.layer.masksToBounds = true
        
        titleLabel.font = UIFont().Body1_M16
        titleLabel.textColor = .black
        titleLabel.backgroundColor = .clear
        titleLabel.textAlignment = .center
        
        descriptionLabel.font = UIFont().Title4_R14
        descriptionLabel.textColor = .gray7
        descriptionLabel.backgroundColor = .clear
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0
        
        cancelButton.setTitle("취소", for: .normal)
        confirmButton.setTitle("확인", for: .normal)
        
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 8
        
        self.snp.makeConstraints { make in
            make.height.equalTo(156)
            make.width.equalTo(344)
        }
        
        self.addSubview(titleLabel)
        self.addSubview(descriptionLabel)
        self.addSubview(stackView)
        stackView.addArrangedSubview(cancelButton)
        stackView.addArrangedSubview(confirmButton)
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(30)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(22)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(48)
            
        }
        
        cancelButton.snp.makeConstraints { make in
            make.height.equalTo(48)
            make.width.equalTo(152)
        }
        confirmButton.snp.makeConstraints { make in
            make.height.equalTo(48)
            make.width.equalTo(152)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
