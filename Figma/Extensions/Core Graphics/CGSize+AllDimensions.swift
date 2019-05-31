//
//  CGSize+AllDimensions.swift
//  IPad_App
//
//  Created by Mohammed Wasimuddin on 18.05.19.
//  Copyright © 2019 Demo. All rights reserved.
//

import UIKit

extension CGSize {
    init(squareLenght: CGFloat) {
        self.init(width: squareLenght, height: squareLenght)
    }
}
