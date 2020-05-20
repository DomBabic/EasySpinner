//
//  CGRect+Center.swift
//  EasySpinner
//
//  Created by Dominik Babić on 20/05/2020.
//  Copyright © 2020 HeliOs. All rights reserved.
//

import UIKit

extension CGRect {
    var center: CGPoint {
        return CGPoint(x: minX + width / 2, y: minY + height / 2)
    }
}
