//
//  Cell.swift
//  Mooskine
//
//  Created by Fabiana Petrovick on 19/05/21.
//  Copyright © 2021 Fabiana Petrovick. All rights reserved.
//

import UIKit

protocol Cell: class {
    /// A default reuse identifier for the cell class
    static var defaultReuseIdentifier: String { get }
}

extension Cell {
    static var defaultReuseIdentifier: String {
        // Should return the class's name, without namespacing or mangling.
        // This works as of Swift 3.1.1, but might be fragile.
        return "\(self)"
    }
}

