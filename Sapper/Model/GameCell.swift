//
//  GameCell.swift
//  Sapper
//
//  Created by Yuri Ivashin on 09.04.2020.
//  Copyright © 2020 The Homber Team. All rights reserved.
//

import UIKit

class GameCell {
    private(set) var row: Int
    private(set) var column: Int
    private(set) var isMined: Bool
    private(set) var state: CellsState
    private(set) var image: UIImage?
    private(set) var numberOfMinesInNeigborhood: Int?
    private(set) var backgroundColor: UIColor? =  ColorNames.darkGray.getColor()
    
    init(row: Int, column: Int, isMined: Bool) {
        self.row = row
        self.column = column
        self.isMined = isMined
        self.state = .closed
    }
    
    convenience init(row: Int, column: Int) {
        self.init(row: row, column: column, isMined: false)
    }
    
    func setMineInCell(as mineExistence: Bool) {
        self.isMined = mineExistence
    }
    
    func changeState(to newState: CellsState) {
        self.state = newState
        
        changeImage()
    }
    
    func setNumberOfMinesInNeigborhood(to value: Int) {
        self.numberOfMinesInNeigborhood = value
    }
    
    private func changeImage() {
        switch state {
        case .exploded:
            image = UIImage(named: "mine")
            backgroundColor = ColorNames.lightGray.getColor()
        case .flagged:
            image = UIImage(named: "flag")
            backgroundColor = ColorNames.lightGray.getColor()
        case .opened:
            if let number = numberOfMinesInNeigborhood {
                switch number {
                case 1...9:
                    image = UIImage(named: "\(number)")
                    backgroundColor = ColorNames.darkGray.getColor()
                default:
                    image = nil
                    backgroundColor = ColorNames.lightGray.getColor()
                }
            } else {
                image = nil
                backgroundColor = ColorNames.lightGray.getColor()
            }
        case .closed:
            image = nil
            backgroundColor = ColorNames.darkGray.getColor()
        }
    }
    
    var description: String {
        return "GameCell(row: \(row), column: \(column), isMined: \(isMined), state: \(state.description), numberOfMinesInNeigborhood: \(String(describing: numberOfMinesInNeigborhood))"
    }
}

extension GameCell: Hashable {
    static func ==(lhs: GameCell, rhs: GameCell) -> Bool {
        return lhs.row == rhs.row && lhs.column == rhs.column
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(row)
        hasher.combine(column)
    }
}
