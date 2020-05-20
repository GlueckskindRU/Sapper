//
//  SettingsController.swift
//  Sapper
//
//  Created by Yuri Ivashin on 13.05.2020.
//  Copyright © 2020 The Homber Team. All rights reserved.
//

import Foundation

typealias FullGameSettings = (gameSettings: GameSettings, rows: Int, columns: Int, numberOfMines: Int)

class SettingsController {
    private var gameSettings: GameSettings
    private var rows: Int
    private var columns: Int
    private var numberOfMines: Int
    private(set) var minRows: Int
    private(set) var maxRows: Int
    private(set) var minColumns: Int
    private(set) var maxColumns: Int
    private(set) var minMines: Int
    private(set) var maxMines: Int
    
    private let easyRows = 14
    private let mediumRows = 14
    private let hardRows = 14
    
    private let easyColumns = 7
    private let mediumColumns = 7
    private let hardColumns = 7
    
    private let easyMines = 10
    private let mediumMines = 15
    private let hardMines = 20
    
    init() {
        let minRowsForCheck = 3
        let maxRowsForCheck = 20
        let minColumnsForCheck = 3
        let maxColumnsForCheck = 10
        
        self.minRows = minRowsForCheck
        self.maxRows = maxRowsForCheck
        
        self.minColumns = minColumnsForCheck
        self.maxColumns = maxColumnsForCheck
        
        self.minMines = 1
        self.maxMines = (maxRowsForCheck * maxColumnsForCheck) - 1
        
        let savedGameSettings = UserDefaults.standard.integer(forKey: AuxiliaryStringKeys.gameSettings.rawValue)
        
        if let gameSettings = GameSettings(rawValue: savedGameSettings) {
            self.gameSettings = gameSettings
        } else {
            self.gameSettings = .easy
        }
        
        switch self.gameSettings {
        case .easy:
            self.rows = easyRows
            self.columns = easyColumns
            self.numberOfMines = easyMines
        case .medium:
            self.rows = mediumRows
            self.columns = mediumColumns
            self.numberOfMines = mediumMines
        case .hard:
            self.rows = hardRows
            self.columns = hardColumns
            self.numberOfMines = hardMines
        case .custom:
            let savedRows = UserDefaults.standard.integer(forKey: AuxiliaryStringKeys.customRows.rawValue)
            let savedColumns = UserDefaults.standard.integer(forKey: AuxiliaryStringKeys.customColumns.rawValue)
            let savedNumberOfMines = UserDefaults.standard.integer(forKey: AuxiliaryStringKeys.customMines.rawValue)
            
            let rowsForCheck: Int
            
            if savedRows > minRowsForCheck && savedRows < maxRowsForCheck {
                self.rows = savedRows
                rowsForCheck = savedRows
            } else {
                self.rows = 14
                rowsForCheck = 14
            }
            
            let columnsForCheck: Int

            if savedColumns > minColumnsForCheck && savedColumns < maxColumnsForCheck {
                self.columns = savedColumns
                columnsForCheck = savedColumns
            } else {
                self.columns = 7
                columnsForCheck = 7
            }
            
            if savedNumberOfMines > 1 && (savedNumberOfMines < (rowsForCheck * columnsForCheck)) {
                self.numberOfMines = savedNumberOfMines
            } else {
                self.numberOfMines = 10
            }
        }
    }
    
    func saveSettings() {
        UserDefaults.standard.set(gameSettings.rawValue, forKey: AuxiliaryStringKeys.gameSettings.rawValue)
        UserDefaults.standard.set(rows, forKey: AuxiliaryStringKeys.customRows.rawValue)
        UserDefaults.standard.set(columns, forKey: AuxiliaryStringKeys.customColumns.rawValue)
        UserDefaults.standard.set(numberOfMines, forKey: AuxiliaryStringKeys.customMines.rawValue)
    }
    
    func set(_ newFullGameSettings: FullGameSettings) {
        self.gameSettings = newFullGameSettings.gameSettings
        
        switch newFullGameSettings.gameSettings {
        case .easy:
            self.rows = easyRows
            self.columns = easyColumns
            self.numberOfMines = easyMines
        case .medium:
            self.rows = mediumRows
            self.columns = mediumColumns
            self.numberOfMines = mediumMines
        case .hard:
            self.rows = hardRows
            self.columns = hardColumns
            self.numberOfMines = hardMines
        case .custom:
            self.rows = newFullGameSettings.rows
            self.columns = newFullGameSettings.columns
            self.numberOfMines = newFullGameSettings.numberOfMines
        }
    }
    
    func getGameSettings() -> FullGameSettings {
        return FullGameSettings(gameSettings: self.gameSettings, rows: self.rows, columns: self.columns, numberOfMines: self.numberOfMines)
    }
}
