//
//  CustomTextFields.swift
//  SeSAC_Friends
//
//  Created by yeop on 2022/01/19.
//

import UIKit
import SkyFloatingLabelTextField

class InputTextField: SkyFloatingLabelTextField {
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        self.font = UIFont().Title4_R14
        self.placeholderColor = .gray7
        self.errorMessagePlacement = .bottom
        self.errorColor = .error
        self.errorLabel.font = UIFont().Body4_R12
        self.tintColor = .black
        self.lineColor = .gray3
        self.selectedLineColor = .focus
        self.borderStyle = .none
        self.backgroundColor = .white
        self.font = UIFont().Title4_R14
        self.textColor = .black
        self.lineHeight = 1.0
        self.title = ""
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = CGRect(
            x: CGFloat(12),
            y: titleHeight() - 12,
            width: bounds.size.width - CGFloat(12),
            height: bounds.size.height - titleHeight() - selectedLineHeight
        )
        return rect
    }
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        
        let rect = CGRect(
            x: CGFloat(12),
            y: titleHeight() - 12,
            width: bounds.size.width - CGFloat(12),
            height: bounds.size.height - titleHeight() - selectedLineHeight
        )
        
        return rect
        
    }
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        
        let rect = CGRect(
            x: CGFloat(12),
            y: titleHeight() - 12,
            width: bounds.size.width - CGFloat(12),
            height: bounds.size.height - titleHeight() - selectedLineHeight
        )
        
        return rect
        
    }
    
    override func errorLabelRectForBounds(_ bounds: CGRect, editing: Bool) -> CGRect {
        let lineRect = lineViewRectForBounds(bounds, editing: editing)
        if editing {
            let originY = lineRect.origin.y + selectedLineHeight + 4
            return CGRect(x: 12, y: originY, width: bounds.size.width, height: errorHeight())
        }
        let originY = lineRect.origin.y + selectedLineHeight + errorHeight() + 4
        return CGRect(x: 12, y: originY, width: bounds.size.width, height: errorHeight())
        
    }
    
}



class AreaTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
