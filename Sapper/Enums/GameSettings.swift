//
//  GameSettings.swift
//  Sapper
//
//  Created by Yuri Ivashin on 13.05.2020.
//  Copyright © 2020 The Homber Team. All rights reserved.
//

import Foundation

enum GameSettings: Int, CaseIterable {
    case easy = 0
    case medium = 1
    case hard = 2
    case custom = 3
    
    static var gameSettingsTitles: [String] = [
        NSLocalizedString("Easy.Text", comment: "GameSettings.Title"),
        NSLocalizedString("Medium.Text", comment: "GameSettings.Title"),
        NSLocalizedString("Hard.Text", comment: "GameSettings.Title"),
        NSLocalizedString("Custom.Text", comment: "GameSettings.Title"),
    ]
}

