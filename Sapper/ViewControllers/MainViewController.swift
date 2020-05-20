//
//  MainViewController.swift
//  Sapper
//
//  Created by Yuri Ivashin on 21.04.2020.
//  Copyright © 2020 The Homber Team. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    @IBOutlet weak var usingFlagHintLabel: UILabel!
    @IBOutlet weak var startNewGameButton: UIButton!
    @IBOutlet weak var settingsView: UIView!
    @IBOutlet weak var gameSettingsSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var rowsLabel: UILabel!
    @IBOutlet weak var rowsStepper: UIStepper!
    
    @IBOutlet weak var columnsLabel: UILabel!
    @IBOutlet weak var columnsStepper: UIStepper!
    
    @IBOutlet weak var minesLabel: UILabel!
    @IBOutlet weak var minesStepper: UIStepper!
    
    @IBAction func rowsStepperChangedValue(_ sender: UIStepper) {
        saveNewSettings()
    }
    
    @IBAction func columsStepperChangedValue(_ sender: UIStepper) {
        saveNewSettings()
    }
    
    @IBAction func minesStepperChangedValue(_ sender: UIStepper) {
        saveNewSettings()
    }
    
    private var settingsController = SettingsController()
    
    @IBAction func startNewGameButtonPressed(_ sender: UIButton) {
        if let gameVC = Bundle.main.loadNibNamed(String(describing: GameViewController.self), owner: nil, options: nil)?.first as? GameViewController {
            let gameSettings = settingsController.getGameSettings()
            gameVC.configure(rows: gameSettings.rows,
                             columns: gameSettings.columns,
                             numberOfMines: gameSettings.numberOfMines)
            gameVC.modalTransitionStyle = .crossDissolve
            gameVC.modalPresentationStyle = .fullScreen
            present(gameVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func gameSettingsSegmentedControlChangedValue(_ sender: UISegmentedControl) {
        saveNewSettings()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        usingFlagHintLabel.text = NSLocalizedString("usingFlagHintLabel.Text", comment: "Label.Text")
        
        startNewGameButton.setTitle(NSLocalizedString("startNewGameButton.Title", comment: "Button.Title"), for: .normal)
        
        setupLayout()
        setupGameSettingsSegmentedControl()
        setupSteppers()
        reloadValuesOfLabelsAndSteppers()
    }
}

extension MainViewController {
    private func setupLayout() {
        startNewGameButton.layer.cornerRadius = 8
        settingsView.layer.cornerRadius = 8
    }
    
    private func setupGameSettingsSegmentedControl() {
        gameSettingsSegmentedControl.removeAllSegments()
        for gameDifficultyIndex in GameSettings.allCases.indices {
            gameSettingsSegmentedControl.insertSegment(withTitle: GameSettings.gameSettingsTitles[gameDifficultyIndex], at: gameDifficultyIndex, animated: false)
        }
        
        let gameSettings = settingsController.getGameSettings()
        
        for gameDifficultyIndex in GameSettings.allCases.indices {
            if gameSettings.gameSettings == GameSettings.allCases[gameDifficultyIndex] {
                gameSettingsSegmentedControl.selectedSegmentIndex = gameDifficultyIndex
            }
        }
        
        if gameSettings.gameSettings == .custom {
            setupEnablingOfSteppers(as: true)
        } else {
            setupEnablingOfSteppers(as: false)
        }
    }
    
    private func setupSteppers() {
        rowsStepper.minimumValue = Double(settingsController.minRows)
        rowsStepper.maximumValue = Double(settingsController.maxRows)
        rowsStepper.stepValue = 1
        
        columnsStepper.minimumValue = Double(settingsController.minColumns)
        columnsStepper.maximumValue = Double(settingsController.maxColumns)
        columnsStepper.stepValue = 1
        
        minesStepper.minimumValue = Double(settingsController.minMines)
        minesStepper.maximumValue = Double(settingsController.maxMines)
        minesStepper.stepValue = 1
    }
    
    private func reloadValuesOfLabelsAndSteppers() {
        let gameSettings = settingsController.getGameSettings()
        
        rowsStepper.value = Double(gameSettings.rows)
        columnsStepper.value = Double(gameSettings.columns)
        minesStepper.value = Double(gameSettings.numberOfMines)
        
        rowsLabel.text = NSLocalizedString("numberOfRowsLabel.Text", comment: "Label.Text") + ": \(gameSettings.rows)"
        columnsLabel.text = NSLocalizedString("numberOfColumnsLabel.Text", comment: "Label.Text") + ": \(gameSettings.columns)"
        minesLabel.text = NSLocalizedString("numberOfMinesLabel.Text", comment: "Label.Text") + ": \(gameSettings.numberOfMines)"
    }
    
    private func setupEnablingOfSteppers(as enablingValue: Bool) {
        rowsStepper.isEnabled = enablingValue
        columnsStepper.isEnabled = enablingValue
        minesStepper.isEnabled = enablingValue
    }
    
    private func saveNewSettings() {
        let newSettings = FullGameSettings(gameSettings: GameSettings.allCases[gameSettingsSegmentedControl.selectedSegmentIndex],
                                           rows: Int(rowsStepper.value),
                                           columns: Int(columnsStepper.value),
                                           numberOfMines: Int(minesStepper.value)
                                            )
        
        settingsController.set(newSettings)
        settingsController.saveSettings()
        
        if newSettings.gameSettings == .custom {
            setupEnablingOfSteppers(as: true)
        } else {
            setupEnablingOfSteppers(as: false)
        }
        
        reloadValuesOfLabelsAndSteppers()
    }
}
