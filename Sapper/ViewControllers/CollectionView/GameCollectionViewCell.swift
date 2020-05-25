//
//  GameCollectionViewCell.swift
//  Sapper
//
//  Created by Yuri Ivashin on 22.04.2020.
//  Copyright © 2020 The Homber Team. All rights reserved.
//

import UIKit

class GameCollectionViewCell: UICollectionViewCell {
    private var cell: GameCell?
    private var delegate: GameCellTapProcessingDelegate?
    
    lazy private var imageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGestureRecognize(_:)))
        tapGestureRecognizer.numberOfTouchesRequired = 1
        imageView.addGestureRecognizer(tapGestureRecognizer)
        
        let longTapGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longTapGestureRecognize(_:)))
        longTapGestureRecognizer.minimumPressDuration = 0.25
        longTapGestureRecognizer.numberOfTouchesRequired = 1
        imageView.addGestureRecognizer(longTapGestureRecognizer)
        
        return imageView
    }()
    
    func configure(cell: GameCell, delegate: GameCellTapProcessingDelegate) {
        self.cell = cell
        self.delegate = delegate
        
        imageView.image = cell.image
        contentView.backgroundColor = cell.backgroundColor
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
    @objc
    private func tapGestureRecognize(_ recognizer: UITapGestureRecognizer) {
        if recognizer.state == .ended,
            let cell = cell {
            delegate?.cellTapProcessing(cell)
        }
    }
    
    @objc
    private func longTapGestureRecognize(_ recognizer: UILongPressGestureRecognizer) {
        guard let cell = cell else {
            return
        }
        
        switch recognizer.state {
        case .began:
            delegate?.cellLongTapStartProcessing()
        case .ended:
            delegate?.cellLongTapProcessing(cell)
        default:
            return
        }
    }
}
