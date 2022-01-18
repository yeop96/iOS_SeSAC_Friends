//
//  CustomButton.swift
//  SeSAC_Friends
//
//  Created by yeop on 2022/01/19.
//

import UIKit


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

