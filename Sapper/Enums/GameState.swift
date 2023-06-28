//
//  GameState.swift
//  Sapper
//
//  Created by Yuri Ivashin on 27.04.2020.
//  Copyright © 2020 The Homber Team. All rights reserved.
//

import Foundation

/// Состояние игры
enum GameState {
    /// В процессе игры
    case playing
    /// Игра завершена выигрышем
    case won
    /// Игра завершена проигрышем
    case lost
}
