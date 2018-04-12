//
//  MemeTextFieldDelegate.swift
//  MemeMe
//
//  Created by Stefan Jaindl on 31.03.18.
//  Copyright © 2018 Stefan Jaindl. All rights reserved.
//

import Foundation
import UIKit

final class MemeTextFieldDelegate: NSObject, UITextFieldDelegate {
    
    var currentTextField : UITextField?
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        currentTextField = textField
        
        if currentTextField!.tag == MemeText.topTag {
            changeText(ifEquals: MemeText.topText, to: "")
        } else {
            changeText(ifEquals: MemeText.bottomText, to: "")
        }
    }
    
    func changeText(ifEquals textToCheck: String, to: String) {
        if currentTextField!.text == textToCheck {
            currentTextField!.text = to
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        currentTextField = textField
        
        if currentTextField!.tag == MemeText.topTag {
            changeText(ifEquals: "", to: MemeText.topText)
        } else {
            changeText(ifEquals: "", to: MemeText.bottomText)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
