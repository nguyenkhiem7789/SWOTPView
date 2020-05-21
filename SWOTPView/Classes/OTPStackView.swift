
import Foundation
import UIKit

protocol OTPDelegate: class {
    /// always triggers when the OTP field is valid
    func didChangeValidity(isValid: Bool)
    func finish()
}

@available(iOS 9.0, *)
class OTPStackView: UIStackView {

    ///Customise the OTPField here
    var numberOfFields: Int = 1 {
        didSet {
            removeOTPFields()
            addOTPFields()
        }
    }

    var textFieldsCollection: [OTPTextField] = []
    weak var delegate: OTPDelegate?
    var showsWarningColor = false

    @IBInspectable
    public var inactiveFieldBorderColor: UIColor = UIColor.black {
        didSet {
            self.updateBorderColorTextField()
        }
    }

    @IBInspectable
    public var textBackgroundColor: UIColor = UIColor.white {
        didSet {
            self.updateBackgroundColorTextField()
        }
    }

    @IBInspectable
    public var textColor: UIColor = UIColor.black {
        didSet {
            self.updateTextColorTextField()
        }
    }

    var activeFieldBorderColor = UIColor.orange
    
    var remainingStrStack: [String] = []

    required init(coder: NSCoder) {
        super.init(coder: coder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStackView()
        addOTPFields()
    }

    ///Customisation and setting stackView
    private final func setupStackView() {
        self.backgroundColor = .clear
        self.isUserInteractionEnabled = true
        self.translatesAutoresizingMaskIntoConstraints = false
        self.contentMode = .center
        self.distribution = .fillEqually
        self.spacing = 5
    }

    ///Adding each OTPfield to stack view
    private final func addOTPFields() {
        guard numberOfFields > 0 else { return }
        for index in 0 ..< numberOfFields {
            let field = OTPTextField()
            setupTextField(field)
            textFieldsCollection.append(field)
            //Adding a marker to previous field
            index != 0 ? (field.previousTextField = textFieldsCollection[index-1]) : (field.previousTextField = nil)
//            //Adding a marker to next for the field at index - 1
            index != 0 ? (textFieldsCollection[index - 1].nextTextField = field) : ()
        }
        textFieldsCollection[0].becomeFirstResponder()
    }

    ///Remove each OTPField from stack view
    private final func removeOTPFields() {
        textFieldsCollection.removeAll()
        while let first = arrangedSubviews.first {
            removeArrangedSubview(first)
            first.removeFromSuperview()
        }
    }

    ///Change color border text field
    private func updateBorderColorTextField() {
        for i in 0 ..< textFieldsCollection.count {
            textFieldsCollection[i].layer.borderColor = inactiveFieldBorderColor.cgColor
        }
    }

    private func updateBackgroundColorTextField() {
        for i in 0 ..< textFieldsCollection.count {
            textFieldsCollection[i].backgroundColor = textBackgroundColor
        }
    }

    private func updateTextColorTextField() {
        for i in 0 ..< textFieldsCollection.count {
            textFieldsCollection[i].textColor = textColor
        }
    }

    ///Customisation and setting OTPTextFields
    private final func setupTextField(_ textField: OTPTextField) {
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        self.addArrangedSubview(textField)
        textField.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        textField.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        textField.widthAnchor.constraint(equalToConstant: 40).isActive = true
        textField.backgroundColor = textBackgroundColor
        textField.textAlignment = .center
        textField.adjustsFontSizeToFitWidth = false
        textField.font = UIFont(name: "System", size: 20)
        textField.textColor = .black
        textField.layer.cornerRadius = 4
        textField.layer.borderWidth = 1
        textField.layer.borderColor = inactiveFieldBorderColor.cgColor
        textField.keyboardType = .numberPad
        textField.autocorrectionType = .yes
        if #available(iOS 12.0, *) {
            textField.textContentType = .oneTimeCode
        } else {
            // Fallback on earlier versions
        }
    }

    ///checks if all the OTPFields are field
    private final func checkForValidity() {
        for fields in textFieldsCollection {
            if(fields.text == "") {
                delegate?.didChangeValidity(isValid: false)
                return
            }
        }
        delegate?.didChangeValidity(isValid: true)
    }

    ///gives the OTP text
    final func getOTP() -> String {
        var OTP = ""
        for textField in textFieldsCollection {
            OTP += textField.text ?? ""
        }
        return OTP
    }

    ///Set isWarningColor true for using it as a warning color
    final func setAllFieldColor(isWarningColor: Bool = false, color: UIColor) {
        for textField in textFieldsCollection {
            textField.layer.borderColor = color.cgColor
        }
        showsWarningColor = isWarningColor
    }

    ///autofill textfield starting from first
    private final func autoFillTextField(with string: String) {
        remainingStrStack = string.reversed().compactMap{String($0)}
        for textField in textFieldsCollection {
            if let charToAdd = remainingStrStack.popLast() {
                textField.text = String(charToAdd)
            } else {
                break
            }
        }
        checkForValidity()
        remainingStrStack = []
    }
}

//MARK: - TextField handing
@available(iOS 9.0, *)
extension OTPStackView: UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        if showsWarningColor {
            setAllFieldColor(color: inactiveFieldBorderColor)
            showsWarningColor = false
        }
        textField.layer.borderColor = activeFieldBorderColor.cgColor
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        checkForValidity()
        textField.layer.borderColor = inactiveFieldBorderColor.cgColor
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textField = textField as? OTPTextField else { return true }
        if string.count > 1 {
            textField.resignFirstResponder()
            autoFillTextField(with: string)
            return false
        } else {
            if(range.length == 0) {
                ///if is last text field
                if textField.nextTextField == nil {
                    delegate?.finish()
                    textField.text? = string
                    textField.resignFirstResponder()
                } else {
                    textField.text? = string
                    textField.nextTextField?.becomeFirstResponder()
                }
                return false
            }
            return true
        }
    }

}
