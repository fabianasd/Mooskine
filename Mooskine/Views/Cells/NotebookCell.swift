//
//  NotebookCell.swift
//  Mooskine
//
//  Created by Fabiana Petrovick on 19/05/21.
//  Copyright © 2021 Fabiana Petrovick. All rights reserved.
//

import UIKit

internal final class NotebookCell: UITableViewCell, Cell {
    // Outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var pageCountLabel: UILabel!

    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        pageCountLabel.text = nil
    }

}
