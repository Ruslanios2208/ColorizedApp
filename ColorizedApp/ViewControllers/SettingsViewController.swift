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
    var delegate: SettingsViewControllerDelegate!
    var viewColor: UIColor!
    
    // MARK: - Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        colorView.layer.cornerRadius = 15

        redValueTF.delegate = self
        greenValueTF.delegate = self
        blueValueTF.delegate = self
        
        colorView.backgroundColor = viewColor
        
        setValue(for: redSlider, greenSlider, blueSlider)
        setValue(for: redValueLabel, greenValueLabel, blueValueLabel)
        setValue(for: redValueTF, greenValueTF, blueValueTF)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    // MARK: - IB Actions
    @IBAction func sliderAction(_ sender: UISlider) {
        switch sender {
        case redSlider:
            setValue(for: redValueLabel)
            setValue(for: redValueTF)
        case greenSlider:
            setValue(for: greenValueLabel)
            setValue(for: greenValueTF)
        default:
            setValue(for: blueValueLabel)
            setValue(for: blueValueTF)
        }
        
        setColor()
    }
    
    @IBAction func doneButtonPressed() {
        delegate.setNewColor(from: colorView.backgroundColor ?? .white)
        dismiss(animated: true)
    }
    
    // MARK: - Private Methods
    private func setColor() {
        colorView.backgroundColor = UIColor(
            red: CGFloat(redSlider.value),
            green: CGFloat(greenSlider.value),
            blue: CGFloat(blueSlider.value),
            alpha: 1
        )
    }

    private func setValue(for labels: UILabel...) {
        labels.forEach { label in
            switch label {
            case redValueLabel: redValueLabel.text = string(from: redSlider)
            case greenValueLabel: greenValueLabel.text = string(from: greenSlider)
            default: blueValueLabel.text = string(from: blueSlider)
            }
        }
    }
    
    private func setValue(for textFields: UITextField...) {
        textFields.forEach { textField in
            switch textField {
            case redValueTF: redValueTF.text = string(from: redSlider)
            case greenValueTF: greenValueTF.text = string(from: greenSlider)
            default: blueValueTF.text = string(from: blueSlider)
            }
        }
    }
    
    private func setValue(for colorSliders: UISlider...) {
        let ciColor = CIColor(color: viewColor)
        colorSliders.forEach { slider in
            switch slider {
            case redSlider: redSlider.value = Float(ciColor.red)
            case greenSlider: greenSlider.value = Float(ciColor.green)
            default: blueSlider.value = Float(ciColor.blue)
            }
        }
    }
    
    private func string(from slider: UISlider) -> String {
        String(format: "%.2f", slider.value)
    }
    
    private func showAlert(title: String, message: String, textField: UITextField? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            textField?.text = "1.00"
            textField?.becomeFirstResponder()
        }
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}

// MARK: - UITextFieldDelegate
extension SettingsViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else {
            showAlert(title: "Wrong format!", message: "Please, enter correct value")
            return
        }
        guard let currentValue = Float(text), (0...1).contains(currentValue) else {
            showAlert(
                title: "Wrong format!",
                message: "Please, enter correct value",
                textField: textField
            )
            return
        }
        
        switch textField {
        case redValueTF:
            redSlider.setValue(currentValue, animated: true)
            setValue(for: redValueLabel)
        case greenValueTF:
            greenSlider.setValue(currentValue, animated: true)
            setValue(for: greenValueLabel)
        default:
            blueSlider.setValue(currentValue, animated: true)
            setValue(for: blueValueLabel)
        }
        
        setColor()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        
        textField.inputAccessoryView = keyboardToolbar
        
        let flexBarButton = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil
        )
        
        let doneButton = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: textField,
            action: #selector(resignFirstResponder)
        )
        
        keyboardToolbar.items = [flexBarButton, doneButton]
    }
}
