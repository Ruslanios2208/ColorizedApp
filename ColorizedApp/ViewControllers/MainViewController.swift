//
//  MainViewController.swift
//  ColorizedApp
//
//  Created by Руслан Шигапов on 12.10.2022.
//

import UIKit

protocol SettingsViewControllerDelegate {
    func setNewColor(from color: UIColor)
}

class MainViewController: UIViewController {
    
    // MARK: - Private Properties
    private var backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)

    // MARK: - Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = backgroundColor
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let settingsVC = segue.destination as? SettingsViewController else { return }
        settingsVC.color = backgroundColor
        settingsVC.delegate = self
    }
}

// MARK: - SettingsViewControllerDelegate
extension MainViewController: SettingsViewControllerDelegate {
    func setNewColor(from color: UIColor) {
        self.backgroundColor = color
        view.backgroundColor = backgroundColor
    }
}
