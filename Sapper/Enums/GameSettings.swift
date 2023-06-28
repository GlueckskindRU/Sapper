//
//  GameSettings.swift
//  Sapper
//
//  Created by Yuri Ivashin on 13.05.2020.
//  Copyright © 2020 The Homber Team. All rights reserved.
//

import Foundation

/// Настройки сложности игры
enum GameSettings: Int, CaseIterable {
    /// Лёгкий уровень сложности
    case easy = 0
    /// Средний уровень сложности
    case medium = 1
    /// Тяжёлый уровень сложности
    case hard = 2
    /// Настраиваемый уровень сложности
    case custom = 3
    
    static var gameSettingsTitles: [String] = [
        NSLocalizedString("Easy.Text", comment: "GameSettings.Title"),
        NSLocalizedString("Medium.Text", comment: "GameSettings.Title"),
        NSLocalizedString("Hard.Text", comment: "GameSettings.Title"),
        NSLocalizedString("Custom.Text", comment: "GameSettings.Title"),
    ]
}

