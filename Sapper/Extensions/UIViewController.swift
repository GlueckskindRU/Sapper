//
//  UIViewController.swift
//  Sapper
//
//  Created by Yuri Ivashin on 18.04.2020.
//  Copyright © 2020 The Homber Team. All rights reserved.
//

import UIKit

extension UIViewController {
    func showAlert(title: String?, message: String?, completion: ((UIAlertAction) -> Void)? = nil) {
        let alertTitle = NSLocalizedString("okAction.Title", comment: "Alert.Ok.Action.Title")
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: alertTitle, style: .default, handler: completion)
        
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
