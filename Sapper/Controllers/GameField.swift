//
//  GameField.swift
//  Sapper
//
//  Created by Yuri Ivashin on 09.04.2020.
//  Copyright © 2020 The Homber Team. All rights reserved.
//

import Foundation

typealias CellCoordinate = (row: Int, column: Int)
typealias NeigborhoodDimensions = (startingRow: Int, checkingRowsLength: Int, startingColumn: Int, checkingColumnsLength: Int)

class GameField {
    private var cellsMatrix: [[GameCell]] = []
    private var rows: Int = 0
    private var columns: Int = 0
    private var numberOfMines: Int = 0
    private var initialTapNoMineShouldBeOpened: Bool = true
    private var neigborhoodCells: Set<GameCell> = []
    private var explodedCellExists: Bool = false
    
// MARK: - Public methods
    func createNewField(rows: Int, columns: Int, numberOfMines: Int) {
        self.cellsMatrix = []
        self.rows = rows
        self.columns = columns
        self.numberOfMines = numberOfMines
        self.initialTapNoMineShouldBeOpened = true
        
        for row in 0..<rows {
            var rowArray: [GameCell] = []
            
            for column in 0..<columns {
                let newCell = GameCell(row: row, column: column)
                rowArray.append(newCell)
            }
            
            cellsMatrix.append(rowArray)
        }
        
        placeMines(numberOfMines)
    }
    
    func open(_ cell: GameCell) {
        if initialTapNoMineShouldBeOpened && cell.isMined {
            moveMineToAnotherCell(from: cell)
        } else {
            initialTapNoMineShouldBeOpened = false
        }
        
        performDirectOpening(of: cell)
    }
    
    func showAllMines() {
        for row in 0..<rows {
            for column in 0..<columns {
                if cellsMatrix[row][column].isMined {
                    self.cellsMatrix[row][column].changeState(to: .exploded)
                }
            }
        }
    }
    
    func setFlag(to cell: GameCell) {
        cell.changeState(to: .flagged)
    }
    
    func unsetFlag(to cell: GameCell) {
        cell.changeState(to: .closed)
    }
    
    func transformMatrixIntoArray() -> [GameCell] {
        var result: [GameCell] = []
        for row in 0..<rows {
            for column in 0..<columns {
                result.append(cellsMatrix[row][column])
            }
        }
        
        return result
    }
    
    func getNumberOfRestOfMines() -> Int {
        var result = 0
        
        for row in 0..<rows {
            for column in 0..<columns {
                if cellsMatrix[row][column].isMined,
                    cellsMatrix[row][column].state == .closed {
                    result += 1
                }
            }
        }
        
        return result
    }
    
    func getNumberOfClosedCells() -> Int {
        var result = 0
        
        for row in 0..<rows {
            for column in 0..<columns {
                if cellsMatrix[row][column].state == .closed {
                    result += 1
                }
            }
        }
        
        return result
    }
    
    func checkGameState() -> GameState {
        guard !explodedCellExists else {
            return .lost
        }
        
        if getNumberOfClosedCells() == getNumberOfRestOfMines() {
            return .won
        }
        
        return .playing
    }
    
// MARK: - Private methods
    private func getRandomCell() -> CellCoordinate {
        let row = Int.random(in: 0..<rows)
        let column = Int.random(in: 0..<columns)
        
        return CellCoordinate(row: row, column: column)
    }
    
    private func placeMines(_ numberOfMines: Int) {
        var i = 0
        repeat {
            let newCoordinate = getRandomCell()
            
            if !cellsMatrix[newCoordinate.row][newCoordinate.column].isMined {
                cellsMatrix[newCoordinate.row][newCoordinate.column].setMineInCell(as: true)
                i += 1
            }
        } while i < numberOfMines
    }
    
    private func moveMineToAnotherCell(from cell: GameCell) {
        var dontBreakTheLoop = true
        
        repeat {
            let newCoordinate = getRandomCell()
            
            if !cellsMatrix[newCoordinate.row][newCoordinate.column].isMined {
                cellsMatrix[newCoordinate.row][newCoordinate.column].setMineInCell(as: true)
                cellsMatrix[cell.row][cell.column].setMineInCell(as: false)
                
                dontBreakTheLoop = false
            }
        } while dontBreakTheLoop
    }
    
    private func performDirectOpening(of cell: GameCell) {
        guard cell.state == .closed else {
            return
        }
        
        guard !cell.isMined else {
            cell.changeState(to: .exploded)
            explodedCellExists = true
            return
        }
        
        neigborhoodCells = []
        
        let qtyOfMinesInNeigborhod = getNumberOfMinesInNeigborhood(for: cell)
        
        if qtyOfMinesInNeigborhod == 0 {
            recursionFilligOfNeigborhoodSet(for: cell)
            
            neigborhoodCells.forEach({
                (openingCell) in
                
                openingProcess(of: openingCell)
            })
        } else {
            openingProcess(of: cell)
        }
    }
    
    private func recursionFilligOfNeigborhoodSet(for cell: GameCell) {
        neigborhoodCells.insert(cell)
        
        getClosedUnMinedCellsInNeigborhood(of: cell).forEach({
            (recursionCell) in
            
            if !neigborhoodCells.contains(recursionCell) {
                recursionFilligOfNeigborhoodSet(for: recursionCell)
            }
        })
    }
    
    private func openingProcess(of cell: GameCell) {
        cell.setNumberOfMinesInNeigborhood(to: self.getNumberOfMinesInNeigborhood(for: cell))
        cell.changeState(to: .opened)
    }
    
    private func getClosedUnMinedCellsInNeigborhood(of cell: GameCell) -> [GameCell] {
        var result: [GameCell] = []
        
        let neigborhoodDimensions = getNeigborhoodDimension(for: cell)
        
        for checkingRow in neigborhoodDimensions.startingRow..<neigborhoodDimensions.startingRow + neigborhoodDimensions.checkingRowsLength {
            for checkingColumn in neigborhoodDimensions.startingColumn..<neigborhoodDimensions.startingColumn + neigborhoodDimensions.checkingColumnsLength {
                let checkingCell = cellsMatrix[checkingRow][checkingColumn]
                
                if checkingCell != cell
                && checkingCell.state == .closed
                && !checkingCell.isMined {
                    let qtyOfMinesInNeigborhood = getNumberOfMinesInNeigborhood(for: checkingCell)
                    
                    if qtyOfMinesInNeigborhood > 0 {
                        openingProcess(of: checkingCell)
                    } else {
                        result.append(checkingCell)
                    }
                }
            }
        }
        
        return result
    }
    
    private func getNumberOfMinesInNeigborhood(for cell: GameCell) -> Int {
        var result = 0

        let neigborhoodDimensions = getNeigborhoodDimension(for: cell)
        
        for checkingRow in neigborhoodDimensions.startingRow..<neigborhoodDimensions.startingRow + neigborhoodDimensions.checkingRowsLength {
            for checkingColumn in neigborhoodDimensions.startingColumn..<neigborhoodDimensions.startingColumn + neigborhoodDimensions.checkingColumnsLength {
                if cellsMatrix[checkingRow][checkingColumn] != cell
                    && cellsMatrix[checkingRow][checkingColumn].isMined {
                    result += 1
                }
            }
        }
        
        return result
    }
    
    private func getNeigborhoodDimension(for cell: GameCell) -> NeigborhoodDimensions {
        let startingRow: Int
        let startingColumn: Int
        let checkingRowsLength: Int
        let checkingColumnsLength: Int
        
        switch cell.row {
        case 0:
            startingRow = 0
            checkingRowsLength = 2
        case rows - 1:
            startingRow = rows - 2
            checkingRowsLength = 2
        default:
            startingRow = cell.row - 1
            checkingRowsLength = 3
        }
        
        switch cell.column {
        case 0:
            startingColumn = 0
            checkingColumnsLength = 2
        case columns - 1:
            startingColumn = columns - 2
            checkingColumnsLength = 2
        default:
            startingColumn = cell.column - 1
            checkingColumnsLength = 3
        }
        
        return NeigborhoodDimensions(startingRow: startingRow, checkingRowsLength: checkingRowsLength, startingColumn: startingColumn, checkingColumnsLength: checkingColumnsLength)
    }
}
