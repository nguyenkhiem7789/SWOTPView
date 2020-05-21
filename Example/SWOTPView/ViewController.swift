//
//  ViewController.swift
//  SWOTPView
//
//  Created by nguyenkhiem7789@gmail.com on 05/20/2020.
//  Copyright (c) 2020 nguyenkhiem7789@gmail.com. All rights reserved.
//

import UIKit
import SWOTPView

class ViewController: UIViewController {

    @IBOutlet weak var otpView: OTPView!

    override func viewDidLoad() {
        super.viewDidLoad()
        otpView.delegate = self
    }

}

extension ViewController: OTPViewDelegate {

    func didChangeValidity(isValid: Bool) {
        print("XcheckOTPView => isValid = \(isValid)")
    }

    func finish() {
        print("XcheckOTPView => finish")
    }

}
