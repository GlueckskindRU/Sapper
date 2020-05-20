//
//  GameFieldCollectionViewDataSource.swift
//  Sapper
//
//  Created by Yuri Ivashin on 22.04.2020.
//  Copyright © 2020 The Homber Team. All rights reserved.
//

import UIKit

class GameFieldCollectionViewDataSource: NSObject {
    private let cellsContainer: [GameCell]
    private let cellProcessingDelegate: GameCellTapProcessingDelegate
    
    init(_ container: [GameCell], cellProcessingDelegate: GameCellTapProcessingDelegate) {
        self.cellsContainer = container
        self.cellProcessingDelegate = cellProcessingDelegate
    }
}

extension GameFieldCollectionViewDataSource: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellsContainer.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(of: GameCollectionViewCell.self, for: indexPath)
        
        cell.configure(cell: cellsContainer[indexPath.row], delegate: cellProcessingDelegate)
        
        return cell
    }
}
