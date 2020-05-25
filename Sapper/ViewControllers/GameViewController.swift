//
//  GameViewController.swift
//  Sapper
//
//  Created by Yuri Ivashin on 22.04.2020.
//  Copyright © 2020 The Homber Team. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    private var rows: Int = 0
    private var columns: Int = 0
    private var numberOfMines: Int = 0
    
    private var gameFieldEngine = GameField()
    
    @IBOutlet weak var minesLeftLabel: UILabel!
    @IBOutlet weak var additionalInfoLabel: UILabel!
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var gameFieldView: UIView!
    
    @IBAction func homeButtonTapped(_ sender: UIButton) {
        if let mainVC = Bundle.main.loadNibNamed(String(describing: MainViewController.self), owner: nil, options: nil)?.first as? MainViewController {
            mainVC.modalTransitionStyle = .crossDissolve
            mainVC.modalPresentationStyle = .fullScreen
            present(mainVC, animated: true, completion: nil)
        }
    }
    
    private var sadSmileImage = UIImage(imageLiteralResourceName: "sadSmile")
    private var happySmileImage = UIImage(imageLiteralResourceName: "happySmile")
    
    private var gameFieldCollectionView: UICollectionView?
    private var gameFieldCollectionViewDataSource: GameFieldCollectionViewDataSource?
    
    func configure(rows: Int, columns: Int, numberOfMines: Int) {
        self.rows = rows
        self.columns = columns
        self.numberOfMines = numberOfMines
        
        gameFieldCollectionView = nil
        gameFieldCollectionViewDataSource = nil
        
        gameFieldEngine.createNewField(rows: rows, columns: columns, numberOfMines: numberOfMines)
        
        createGameFieldCollectionView()
        setupGameFieldCollectionViewLayout()
        
        homeButton.setImage(happySmileImage, for: .normal)
        
        refreshView()
    }
    
    private func refreshView() {
        gameFieldCollectionView?.reloadData()
        minesLeftLabel.text = "\(gameFieldEngine.getNumberOfRestOfMines())"
        additionalInfoLabel.text = "\(gameFieldEngine.getNumberOfClosedCells())"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GameCenterController.shared.viewContoller = self
    }
}

// MARK: - Extension for a GameFieldCollectionView
extension GameViewController {
    private func createGameFieldCollectionView() {
        let flowLayout = GameFieldCollectionViewLayout(rows: rows, columns: columns)
        let frame = CGRect(x: 0,
                           y: 0,
                           width: gameFieldView.frame.width,
                           height: gameFieldView.frame.height
                        )
        
        gameFieldCollectionView = UICollectionView(frame: frame, collectionViewLayout: flowLayout)
        gameFieldCollectionView?.translatesAutoresizingMaskIntoConstraints = false
        
        gameFieldCollectionViewDataSource = GameFieldCollectionViewDataSource(gameFieldEngine.transformMatrixIntoArray(), cellProcessingDelegate: self)
        gameFieldCollectionView?.dataSource = gameFieldCollectionViewDataSource
        gameFieldCollectionView?.backgroundColor = UIColor(named: "lightGrayInLightAppearanceColor")
        gameFieldCollectionView?.register(cellType: GameCollectionViewCell.self, nib: false)
    }
    
    private func setupGameFieldCollectionViewLayout() {
        guard let gameFieldCollectionView = gameFieldCollectionView else {
            return
        }
        
        if !gameFieldView.subviews.isEmpty {
            gameFieldView.removeSubviews(of: UICollectionView.self)
        }
        
        gameFieldView.addSubview(gameFieldCollectionView)
        
        NSLayoutConstraint.activate([
            gameFieldCollectionView.topAnchor.constraint(equalTo: gameFieldView.topAnchor, constant: 0),
            gameFieldCollectionView.leadingAnchor.constraint(equalTo: gameFieldView.leadingAnchor, constant: 0),
            gameFieldView.trailingAnchor.constraint(equalTo: gameFieldCollectionView.trailingAnchor, constant: 0),
            gameFieldView.bottomAnchor.constraint(equalTo: gameFieldCollectionView.bottomAnchor, constant: 0),
        ])
    }
}

extension GameViewController: GameCellTapProcessingDelegate {
    func cellTapProcessing(_ cell: GameCell) {
        guard gameFieldEngine.checkGameState() == .playing else {
            return
        }

        gameFieldEngine.open(cell)
        
        switch gameFieldEngine.checkGameState() {
        case .lost:
            UIDevice.vibrate()
            gameFieldEngine.showAllMines()
            homeButton.setImage(sadSmileImage, for: .normal)
        case .won:
            showAlert(title: NSLocalizedString("congratulationsAlert.Title", comment: "Alert.Title"), message: NSLocalizedString("congratulaltionsAlert.Message", comment: "Alert.Message"))
        default:
            break
        }
        
        refreshView()
    }
    
    func cellLongTapProcessing(_ cell: GameCell) {
        guard gameFieldEngine.checkGameState() == .playing else {
            return
        }
        
        switch cell.state {
        case .flagged:
            gameFieldEngine.unsetFlag(to: cell)
        case .closed:
            gameFieldEngine.setFlag(to: cell)
        default:
            return
        }
        
        refreshView()
    }
    
    func cellLongTapStartProcessing() {
        guard gameFieldEngine.checkGameState() == .playing else {
            return
        }
        
        UIDevice.vibrate()
    }
}
