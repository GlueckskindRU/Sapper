//
//  GameFieldCollectionViewLayout.swift
//  Sapper
//
//  Created by Yuri Ivashin on 22.04.2020.
//  Copyright © 2020 The Homber Team. All rights reserved.
//

import UIKit

class GameFieldCollectionViewLayout: UICollectionViewLayout {
    private let numberOfRows: Int
    private let numberOfColumns: Int
    private let defaultCellPadding: CGFloat = 8
    private var cachedLayoutAttributes: [UICollectionViewLayoutAttributes] = []
    
    init(rows: Int, columns: Int) {
        numberOfRows = rows
        numberOfColumns = columns
        
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder) has not been implemented")
    }
    
    private var cellSize: CGFloat {
        return min(cellWidth, cellHeight)
    }
    
    private var cellWidth: CGFloat {
        let defaultSize: CGFloat = 50
        
        guard let collectionView = collectionView else {
            return defaultSize
        }
        
        return (collectionView.bounds.width / CGFloat(numberOfColumns)) - (2 * defaultCellPadding)
    }
    
    private var cellHeight: CGFloat {
        let defaultSize: CGFloat = 50
        
        guard let collectionView = collectionView else {
            return defaultSize
        }
        
        return (collectionView.bounds.height / CGFloat(numberOfRows)) - (2 * defaultCellPadding)
    }
    
    private var cellWidthPadding: CGFloat {
        guard let collectionView = collectionView else {
            return defaultCellPadding
        }
        
        if cellWidth < cellHeight {
            return defaultCellPadding
        } else {
            return ((collectionView.bounds.width / CGFloat(numberOfColumns)) - cellHeight) / 2
        }
    }
    
    private var cellHeightPadding: CGFloat {
        guard let collectionView = collectionView else {
            return defaultCellPadding
        }
        
        if cellHeight < cellWidth {
            return defaultCellPadding
        } else {
            return ((collectionView.bounds.height / CGFloat(numberOfRows)) - cellWidth) / 2
        }
    }
    
    private var contentWidth: CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        
        let insets = collectionView.contentInset
        
        return collectionView.bounds.width - (insets.left + insets.right)
    }
    
    private var contentHeight: CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        
        let insets = collectionView.contentInset
        
        return collectionView.bounds.height - (insets.top + insets.bottom)
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: cellSize, height: cellSize)
    }
    
    override func prepare() {
        guard
            cachedLayoutAttributes.isEmpty,
            let collectionView = collectionView else {
                return
        }
        
        let columnWidth = (contentWidth) / CGFloat(numberOfColumns)
        var column = 0
        var row = 0
        
        let startYOffset = (collectionView.bounds.height - contentHeight) / 2
        var yOffset: [CGFloat] = .init(repeating: startYOffset, count: numberOfColumns)
        let totalItems = collectionView.numberOfItems(inSection: 0)
        
        for item in 0..<totalItems {
            let indexPath = IndexPath(item: item, section: 0)
            let height = (cellHeightPadding * 2) + cellSize
            
            let frame = CGRect(x: CGFloat(column) * columnWidth,
                               y: yOffset[column],
                               width: columnWidth,
                               height: height
                                )
            
            let insetFrame = frame.insetBy(dx: cellWidthPadding, dy: cellHeightPadding)
            let layoutAttribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            layoutAttribute.frame = insetFrame
            cachedLayoutAttributes.append(layoutAttribute)
            
            yOffset[column] = yOffset[column] + height
            if column < (numberOfColumns - 1) {
                column += 1
            } else {
                column = 0
                row += 1
            }
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        // all cells should be allways visibled
        return cachedLayoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cachedLayoutAttributes[indexPath.item]
    }
}
