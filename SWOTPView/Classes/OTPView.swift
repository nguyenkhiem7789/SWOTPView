//
//  OTPView.swift
//  FBSnapshotTestCase
//
//  Created by Nguyen on 5/20/20.
//

import UIKit

public protocol OTPViewDelegate: class {
    /// always triggers when the OTP field is valid
    func didChangeValidity(isValid: Bool)
    func finish()
}

@available(iOS 9.0, *)
@IBDesignable
public class OTPView: UIView {

    let otpStackView = OTPStackView()
    public weak var delegate: OTPViewDelegate?

    @IBInspectable
    public var numberOfFields: Int = 1 {
        didSet {
            otpStackView.numberOfFields = numberOfFields
        }
    }

    @IBInspectable
    public var inactiveFieldBorderColor: UIColor = UIColor.black {
        didSet {
            otpStackView.inactiveFieldBorderColor = inactiveFieldBorderColor
        }
    }

    @IBInspectable
    public var textBackgroundColor: UIColor = UIColor.white {
        didSet {
            otpStackView.textBackgroundColor = textBackgroundColor
        }
    }

    @IBInspectable
    public var activeFieldBorderColor: UIColor = UIColor.white {
        didSet {
            otpStackView.activeFieldBorderColor = activeFieldBorderColor
        }
    }

    @IBInspectable
    public var textColor: UIColor = UIColor.black {
        didSet {
            otpStackView.textColor = textColor
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initView()
    }

    private func initView() {
        otpStackView.delegate = self
        addSubview(otpStackView)
        otpStackView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        otpStackView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        otpStackView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }

}

@available(iOS 9.0, *)
extension OTPView: OTPDelegate {

    func didChangeValidity(isValid: Bool) {
        delegate?.didChangeValidity(isValid: isValid)
    }

    func finish() {
        delegate?.finish()
    }

}
