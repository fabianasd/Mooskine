//
//  Notebook+Extensions.swift
//  Mooskine
//
//  Created by Fabiana Petrovick on 30/05/21.
//  Copyright © 2021 Fabiana Petrovick. All rights reserved.
//

import UIKit
import CoreData

extension Notebook {
    public override func awakeFromInsert() {
        super.awakeFromInsert() //chamar
        creationDate = Date() // configuramos creationDate como data atual
    }
}
