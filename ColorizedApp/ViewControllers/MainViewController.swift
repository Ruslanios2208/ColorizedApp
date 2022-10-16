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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let settingsVC = segue.destination as? SettingsViewController else { return }
        settingsVC.delegate = self
        settingsVC.viewColor = view.backgroundColor
    }
}

// MARK: - SettingsViewControllerDelegate
extension MainViewController: SettingsViewControllerDelegate {
    func setNewColor(from color: UIColor) {
        view.backgroundColor = color
    }
}
