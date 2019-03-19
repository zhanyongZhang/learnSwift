//
//  PhoneField.swift
//  PhoneTextFieldDemo
//
//  Created by allen_zhang on 2019/3/14.
//  Copyright © 2019 com.mljr. All rights reserved.
//

import UIKit

class PhoneField: UITextField {
   
    var _previousText: String!
    var _previousRange: UITextRange!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
       
        self.borderStyle = UITextField.BorderStyle.roundedRect
        self.keyboardType = UIKeyboardType.numberPad
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        
        if newSuperview != nil {
            
            NotificationCenter.default.addObserver(self, selector: #selector(phoneNumberFormat(_:)), name: UITextField.textDidChangeNotification, object: nil)
            
        } else {
            
            NotificationCenter.default.removeObserver(self)
        }
    }
    
    @objc func phoneNumberFormat(_ notification: NSNotification) {
        
        let textField = notification.object as! UITextField
        if !textField.isEqual(self) {
            return
        }
        
        if (textField.text != "" && (textField.text![0] as NSString).intValue != 1) {
            textField.text = _previousText
            let start = textField.beginningOfDocument
            textField.selectedTextRange = textField.textRange(from: start, to: start)
            return
        }
        var cursorPostion = textField.offset(from: textField.beginningOfDocument, to: textField.selectedTextRange!.start)
        
        let digitsText = getDigitsText(string: textField.text!, cursorPosition: &cursorPostion)
        
        if digitsText.count > 11 {
            textField.text = _previousText
            textField.selectedTextRange = _previousRange
            return
        }
        
        let hyphenText = getHyphenText(string: digitsText, cursorPosition: &cursorPostion)
        textField.text = hyphenText
        
        let targetPostion = textField.position(from: textField.beginningOfDocument, offset: cursorPostion)!
        textField.selectedTextRange = textField.textRange(from: targetPostion, to: targetPostion)
        
        _previousText = self.text!
        _previousRange = self.selectedTextRange!
        
    }
    
    func getDigitsText(string: String, cursorPosition: inout Int) -> String {
        
        let originalCursorPosition = cursorPosition
        var result = ""
        var i = 0
        for uni in string.unicodeScalars {
            
            if CharacterSet.decimalDigits.contains(uni) {
                result.append(string[i])
            } else {
                
                if i < originalCursorPosition {
                    cursorPosition = cursorPosition - 1
                }
            }
            i = i + 1
        }
        return result
    }
    
    func getHyphenText(string: String, cursorPosition: inout Int) -> String {
        
        let originalCursorPosition = cursorPosition
        var result = ""
        
        for i in 0 ..< string.count {
            
            if i == 3 || i == 7 {
                result.append("-")
                if i < originalCursorPosition {
                    cursorPosition = cursorPosition + 1
                }
            }
            result.append(string[i])
        }
        return result
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension String {
    
    subscript(index: Int) -> String {
    
        get {
   
            return String(self[self.index(self.startIndex, offsetBy: index)])
        }
        
        set {
            let temp = self
            self = ""
            
            for (dx, tm) in temp.enumerated() {
                
                if dx == index {
                    self += "\(newValue)"
                } else {
                    self += "\(tm)"
                }
            }
        }
    }
}
