//
//  GameCenterController.swift
//  Sapper
//
//  Created by Yuri Ivashin on 25.05.2020.
//  Copyright © 2020 The Homber Team. All rights reserved.
//

import GameKit

class GameCenterController: NSObject {
    static let shared = GameCenterController()
    
    var viewContoller: UIViewController?
    
    override init() {
        super.init()
        
        GKLocalPlayer.local.authenticateHandler = {
            (gcAuthVC, error) in
            
            NotificationCenter.default.post(name: .authenticationChanged, object: GKLocalPlayer.local.isAuthenticated)
            
            if GKLocalPlayer.local.isAuthenticated {
                print("Authenticated to Game Center")
            } else if let vc = gcAuthVC {
                self.viewContoller?.present(vc, animated: true)
            } else {
                print("Error authentication to Game Center: \(error?.localizedDescription ?? "none")")
            }
        }
    }
}

extension Notification.Name {
    static let presentGame = Notification.Name(rawValue: "presentGame")
    static let authenticationChanged = Notification.Name(rawValue: "authenticationChanged")
}
