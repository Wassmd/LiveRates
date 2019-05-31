//
//  Optional+Generic.swift
//  IPad_App
//
//  Created by Mohammed Wasimuddin on 19.05.19.
//  Copyright © 2019 Demo. All rights reserved.
//

import Foundation

protocol OptionalType {
    associatedtype Wrapped
    var value: Wrapped? { get }
}

extension Optional: OptionalType {
    var value: Wrapped? { return self }
}
