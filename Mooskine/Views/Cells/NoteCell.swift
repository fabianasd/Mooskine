//
//  NoteCell.swift
//  Mooskine
//
//  Created by Fabiana Petrovick on 19/05/21.
//  Copyright © 2021 Fabiana Petrovick. All rights reserved.
//

import UIKit

internal final class NoteCell: UITableViewCell, Cell {
    // Outlets
    @IBOutlet weak var textPreviewLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    override func prepareForReuse() {
        super.prepareForReuse()
        textPreviewLabel.text = nil
        dateLabel.text = nil
    }
}
