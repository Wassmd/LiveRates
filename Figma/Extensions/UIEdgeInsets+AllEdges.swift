//
//  UIEdgeInsets+AllEdges.swift
//  IPad_App
//
//  Created by Mohammed Wasimuddin on 18.05.19.
//  Copyright © 2019 Demo. All rights reserved.
//

import UIKit

extension UIEdgeInsets {
    
    init(inset: CGFloat) {
        self.init(top: inset, left: inset, bottom: inset, right: inset)
    }
}
