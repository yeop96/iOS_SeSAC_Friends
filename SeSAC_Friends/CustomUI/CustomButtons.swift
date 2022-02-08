//
//  CustomButton.swift
//  SeSAC_Friends
//
//  Created by yeop on 2022/01/19.
//

import UIKit
import SnapKit

class InactiveButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 8
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.gray4.cgColor
        self.backgroundColor = .white
        self.setTitleColor(.black, for: .normal)
        self.titleLabel?.font = UIFont().Body3_R14
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func clicked() {
        self.layer.borderWidth = 0
        self.backgroundColor = .green
        self.setTitleColor(.white, for: .normal)
        self.titleLabel?.font = UIFont().Body3_R14
    }
    
    func unclicked() {
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.gray4.cgColor
        self.backgroundColor = .white
        self.setTitleColor(.black, for: .normal)
    }
}

class FillButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 8
        self.backgroundColor = .green
        self.setTitleColor(.white, for: .normal)
        self.titleLabel?.font = UIFont().Body3_R14
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class OutlineButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 8
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.green.cgColor
        self.backgroundColor = .white
        self.setTitleColor(.green, for: .normal)
        self.titleLabel?.font = UIFont().Body3_R14
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class CancelButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 8
        self.backgroundColor = .gray2
        self.setTitleColor(.black, for: .normal)
        self.titleLabel?.font = UIFont().Body3_R14
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class DisableButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 8
        self.backgroundColor = .gray6
        self.setTitleColor(.gray3, for: .normal)
        self.titleLabel?.font = UIFont().Body3_R14
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class ToggleButton: UIView {
    let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.layer.masksToBounds = true
        
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "toggleOff")
        imageView.backgroundColor = .clear
        
        self.addSubview(imageView)
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func toggleOn() {
        imageView.image = UIImage(named: "toggleOn")
    }
    
    func toggleOff() {
        imageView.image = UIImage(named: "toggleOff")
    }
    
}

class ImageButton: UIView {
    let imageView = UIImageView()
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = 8
        self.backgroundColor = .white
        self.layer.borderColor = UIColor.gray3.cgColor
        self.layer.borderWidth = 1
        self.layer.masksToBounds = true
        
        imageView.backgroundColor = .clear
        
        label.font = UIFont().Title2_R16
        label.textColor = .black
        label.backgroundColor = .clear
        
        self.addSubview(label)
        self.addSubview(imageView)
        
        label.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-14)
        }
        
        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(label.snp.top).offset(-12)
            make.height.equalTo(64)
            make.width.equalTo(64)
        }
       
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func clicked() {
        self.backgroundColor = .whiteGreen
        self.layer.borderColor = UIColor.whiteGreen.cgColor
        self.layer.borderWidth = 1
        self.layer.masksToBounds = true
        
    }
    
    func unclicked() {
        self.backgroundColor = .white
        self.layer.borderColor = UIColor.gray3.cgColor
        self.layer.borderWidth = 1
        self.layer.masksToBounds = true
    }
}

class FilterButton: UIView {
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.layer.cornerRadius = 8
        stackView.layer.masksToBounds = true
        return stackView
    }()
    let allButton = UIButton()
    let maleButton = UIButton()
    let femaleButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = 8
        self.clipsToBounds = false
        self.backgroundColor = .white
        self.layer.masksToBounds = false
        
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3).cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 3
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        
        allButton.setTitle("전체", for: .normal)
        maleButton.setTitle("남자", for: .normal)
        femaleButton.setTitle("여자", for: .normal)
        
        allButton.addTarget(self, action: #selector(allButtonClicked), for: .touchUpInside)
        maleButton.addTarget(self, action: #selector(maleButtonClicked), for: .touchUpInside)
        femaleButton.addTarget(self, action: #selector(femaleButtonClicked), for: .touchUpInside)
        
        self.addSubview(stackView)
        
        [allButton, maleButton, femaleButton].forEach {
            $0.titleLabel?.font = UIFont().Title4_R14
            $0.backgroundColor = .white
            $0.setTitleColor(.black, for: .normal)
            stackView.addArrangedSubview($0)
            $0.snp.makeConstraints { make in
                make.size.equalTo(48)
            }
        }
        
        self.snp.makeConstraints { make in
            make.height.equalTo(144)
            make.width.equalTo(48)
        }
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
       
    }
    
    @objc func allButtonClicked(sender: UIButton){
        buttonClicked(sender: sender)
        buttonUnClicked(sender: maleButton)
        buttonUnClicked(sender: femaleButton)
    }
    @objc func maleButtonClicked(sender: UIButton){
        buttonClicked(sender: sender)
        buttonUnClicked(sender: allButton)
        buttonUnClicked(sender: femaleButton)
    }
    @objc func femaleButtonClicked(sender: UIButton){
        buttonClicked(sender: sender)
        buttonUnClicked(sender: maleButton)
        buttonUnClicked(sender: allButton)
    }
    
    func buttonClicked(sender: UIButton){
        sender.titleLabel?.font = UIFont().Title3_M14
        sender.backgroundColor = .green
        sender.setTitleColor(.white, for: .normal)
    }
    
    func buttonUnClicked(sender: UIButton){
        sender.titleLabel?.font = UIFont().Title4_R14
        sender.backgroundColor = .white
        sender.setTitleColor(.black, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class FloatingButton: UIButton {
    
    enum MatchingStatus {
        case search, matching, matched
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(status: MatchingStatus) {
        self.init(frame: .zero)
        
        setup(status: status)
    }
    
    func setup(status: MatchingStatus? = nil) {
        switch status {
        case .search:
            self.setImage(UIImage(named: "default_status_button"), for: .normal)
        case .matching:
            self.setImage(UIImage(named: "matching_status_button"), for: .normal)
        case .matched:
            self.setImage(UIImage(named: "matched_status_button"), for: .normal)
        case .none:
            print("none")
        }
        self.layer.cornerRadius = self.frame.width / 2
        self.layer.masksToBounds = true
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3).cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 3
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        
        self.snp.makeConstraints { make in
            make.size.equalTo(64)
        }
    }
    
}

class GPSButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.layer.cornerRadius = 8
        self.clipsToBounds = false
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3).cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 3
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        
        self.setImage(UIImage(named: "place"), for: .normal)
        self.contentEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        self.snp.makeConstraints { make in
            make.size.equalTo(48)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
