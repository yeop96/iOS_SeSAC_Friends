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


