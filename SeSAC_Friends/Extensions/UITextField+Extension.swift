//
//  UITextField+Extension.swift
//  SeSAC_Friends
//
//  Created by yeop on 2022/01/21.
//

import UIKit
import AnyFormatKit

extension UITextField {
    func formatPhoneNumber(range: NSRange, string: String) {
        guard let text = self.text else {
            return
        }
        let characterSet = CharacterSet(charactersIn: string)
        if CharacterSet.decimalDigits.isSuperset(of: characterSet) == false {
            return
        }

        let newLength = text.count + string.count - range.length
        let formatter: DefaultTextInputFormatter
        let onlyPhoneNumber = text.filter { $0.isNumber }

        let currentText: String
        if newLength < 13 {
            if text.count == 13, string.isEmpty { // crash 방지
                formatter = DefaultTextInputFormatter(textPattern: "###-####-####")
            } else {
                formatter = DefaultTextInputFormatter(textPattern: "###-###-####")
            }
        } else {
            formatter = DefaultTextInputFormatter(textPattern: "###-####-####")
        }

        currentText = formatter.format(onlyPhoneNumber) ?? ""
        let result = formatter.formatInput(currentText: currentText, range: range, replacementString: string)
        if text.count == 13, string.isEmpty {
            self.text = DefaultTextInputFormatter(textPattern: "###-###-####").format(result.formattedText.filter { $0.isNumber })
        } else {
            self.text = result.formattedText
        }

        let position: UITextPosition
        
        
        position = self.position(from: self.beginningOfDocument, offset: result.caretBeginOffset)!
        

        self.selectedTextRange = self.textRange(from: position, to: position)
    }
    
    //텍스트필드 클릭시 데이트피커 짜잔!
    func setDatePicker(target: Any, selector: Selector?) {
        let SCwidth = self.bounds.width
        //let SCheight = self.bounds.height
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: SCwidth, height: 216))
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "ko-KR")
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        self.inputView = datePicker
        datePicker.addTarget(self, action: #selector(handleDatePicker(_:)), for: .valueChanged)
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: SCwidth, height: 44.0))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancel = UIBarButtonItem(title: "취소", style: .plain, target: nil, action: #selector(tapCancel))
        let barButton = UIBarButtonItem(title: "완료", style: .plain, target: target, action: selector)
        toolBar.setItems([cancel, flexible, barButton], animated: false)
        self.inputAccessoryView = toolBar
        
    }
    @objc func tapCancel() {
        self.resignFirstResponder()
    }
    @objc private func handleDatePicker(_ sender: UIDatePicker) {
        UserData.birth = sender.date
    }
}
