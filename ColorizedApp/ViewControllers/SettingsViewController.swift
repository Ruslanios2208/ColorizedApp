//
//  SettingsViewController.swift
//  ColorizedApp
//
//  Created by Руслан Шигапов on 24.09.2022.
//

import UIKit

class SettingsViewController: UIViewController {

    // MARK: - IB Outlets
    @IBOutlet var colorView: UIView!
    
    @IBOutlet var redValueLabel: UILabel!
    @IBOutlet var greenValueLabel: UILabel!
    @IBOutlet var blueValueLabel: UILabel!
    
    @IBOutlet var redSlider: UISlider!
    @IBOutlet var greenSlider: UISlider!
    @IBOutlet var blueSlider: UISlider!
    
    @IBOutlet var redValueTF: UITextField!
    @IBOutlet var greenValueTF: UITextField!
    @IBOutlet var blueValueTF: UITextField!
    
    // MARK: - Public Properties
    var color: UIColor!
    var delegate: SettingsViewControllerDelegate!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        colorView.layer.cornerRadius = 15
        updateValue()
        setValue()
        setColor()
        
        redValueTF.delegate = self
        greenValueTF.delegate = self
        blueValueTF.delegate = self
        
        redValueTF.addDoneButtonOnKeyboard()
        greenValueTF.addDoneButtonOnKeyboard()
        blueValueTF.addDoneButtonOnKeyboard()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    // MARK: - IB Actions
    @IBAction func sliderAction(_ sender: UISlider) {
        setColor()
        switch sender {
        case redSlider:
            redValueLabel.text = string(from: sender)
            redValueTF.text = string(from: sender)
        case greenSlider:
            greenValueLabel.text = string(from: sender)
            greenValueTF.text = string(from: sender)
        default:
            blueValueLabel.text = string(from: sender)
            blueValueTF.text = string(from: sender)
        }
    }
    
    @IBAction func DoneButtonPressed() {
        delegate.setNewColor(from: colorView.backgroundColor ?? .white)
        dismiss(animated: true)
    }
    
    // MARK: - Private Methods
    private func setColor() {
        colorView.backgroundColor = UIColor(red: CGFloat(redSlider.value),
                                            green: CGFloat(greenSlider.value),
                                            blue: CGFloat(blueSlider.value),
                                            alpha: 1.0)
    }

    private func setValue() {
        redValueLabel.text = string(from: redSlider)
        greenValueLabel.text = string(from: greenSlider)
        blueValueLabel.text = string(from: blueSlider)
        
        redValueTF.text = string(from: redSlider)
        greenValueTF.text = string(from: greenSlider)
        blueValueTF.text = string(from: blueSlider)
    }
    
    private func string(from slider: UISlider) -> String {
        String(format: "%.2f", slider.value)
    }
    
    private func updateValue() {
        redSlider.value = Float(color?.rgba.red ?? 1.0)
        greenSlider.value = Float(color?.rgba.green ?? 1.0)
        blueSlider.value = Float(color?.rgba.blue ?? 1.0)
    }
}

// MARK: - UIColor
extension UIColor {
    var rgba: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        return (red, green, blue, alpha)
    }
}

// MARK: - UITextFieldDelegate
extension SettingsViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let newValue = textField.text else {
            showAlert(
                withTitle: "Wrong format!",
                andMessage: "Please, enter correct value",
                textField: textField
            )
            return
        }
        guard let numberValue = Float(newValue) else {
            showAlert(
                withTitle: "Wrong format!",
                andMessage: "Please, enter correct value",
                textField: textField
            )
            return
        }
        if textField == redValueTF {
            redSlider.value = numberValue
            redValueLabel.text = newValue
            setColor()
        } else if textField == greenValueTF {
            greenSlider.value = numberValue
            greenValueLabel.text = newValue
            setColor()
        } else {
            blueSlider.value = numberValue
            blueValueLabel.text = newValue
            setColor()
        }
    }
}

// MARK: - UITextField
extension UITextField {
    func addDoneButtonOnKeyboard(){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction() {
         self.resignFirstResponder()
     }
}

// MARK: - UIAlertController
extension SettingsViewController {
    private func showAlert(withTitle title: String, andMessage message: String, textField: UITextField? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            textField?.text = ""
        }
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}
