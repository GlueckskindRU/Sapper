//
//  ColorNames.swift
//  Sapper
//
//  Created by Yuri Ivashin on 28.05.2020.
//  Copyright © 2020 The Homber Team. All rights reserved.
//

import UIKit

enum ColorNames: String {
    case lightGray = "lightGrayInLightAppearanceColor"
    case darkGray = "darkGrayInLightAppearanceColor"
    
    func getColor() -> UIColor? {
        return UIColor(named: self.rawValue)
    }
}
