//
//  CellsState.swift
//  Sapper
//
//  Created by Yuri Ivashin on 09.04.2020.
//  Copyright © 2020 The Homber Team. All rights reserved.
//

import Foundation

enum CellsState {
    case closed
    case opened
    case flagged
    case exploded
    
    var description: String {
        switch self {
        case .closed:
            return "closed"
        case .exploded:
            return "exploded"
        case .flagged:
            return "flagged"
        case .opened:
            return "opened"
        }
    }
}
