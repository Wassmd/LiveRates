//
//  ResuableView.swift
//  IPad_App
//
//  Created by Mohammed Wasimuddin on 18.05.19.
//  Copyright © 2019 Demo. All rights reserved.
//

import UIKit

protocol ReusableView: AnyObject {
    static var reuseString: String { get }
}

extension ReusableView {
    static var reuseString: String {
        return String(describing: self)
    }
}

extension UICollectionReusableView: ReusableView {}
