//
//  LinkTableViewCell.swift
//  PodcastEdit
//
//  Created by Alexander Shoshiashvili on 16.09.2020.
//  Copyright © 2020 Илья Егоров. All rights reserved.
//

import UIKit
import SwiftyListKit

final class LinkTableViewCell: UITableViewCell, TableItem {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var infoLabel: UILabel!
    
    weak var delegate: TextViewTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
}

extension LinkTableViewCell {
    
    static func map(data: TitleSubtitleAndValue<String>, cell: LinkTableViewCell) {
        cell.titleLabel.text = data.title
        cell.subtitleLabel.text = data.subtitle
        cell.infoLabel.text = data.value
    }
    
}
