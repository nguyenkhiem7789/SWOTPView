//
//  OTPTextField.swift
//  FBSnapshotTestCase
//
//  Created by Nguyen on 5/20/20.
//

import Foundation
import UIKit

class OTPTextField: UITextField {

    weak var previousTextField: OTPTextField?
    weak var nextTextField: OTPTextField?

    override public func deleteBackward() {
        text = ""
        previousTextField?.becomeFirstResponder()
    }

}
