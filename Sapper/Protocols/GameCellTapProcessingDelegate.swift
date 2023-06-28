//
//  GameCellTapProcessingDelegate.swift
//  Sapper
//
//  Created by Yuri Ivashin on 22.04.2020.
//  Copyright © 2020 The Homber Team. All rights reserved.
//

import Foundation

protocol GameCellTapProcessingDelegate: AnyObject {
    func cellTapProcessing(_ cell: GameCell)
    func cellLongTapProcessing(_ cell: GameCell)
    func cellLongTapStartProcessing()
}
