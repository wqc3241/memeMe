//
//  textDelegate.swift
//  memeMe
//
//  Created by Qichao Wang on 2017/6/12.
//  Copyright © 2017年 Qichao Wang. All rights reserved.
//

import Foundation
import UIKit

class textDelegate: NSObject, UITextFieldDelegate{
    
    var textHolder: String!
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textHolder = textField.placeholder
        textField.placeholder = ""
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text == ""{
            textField.placeholder = textHolder
        }
            
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true;
    }
    
}
