//
//  EmptyStateTableViewCell.swift
//  PodcastEdit
//
//  Created by Alexander Shoshiashvili on 16.09.2020.
//  Copyright © 2020 Илья Егоров. All rights reserved.
//

import UIKit
import SwiftyListKit

protocol EmptyStateTableViewCellDelegate: Delegatable {
    func emptyStateTableViewCellDidPressOnAction(_ cell: EmptyStateTableViewCell)
}

final class EmptyStateTableViewCell: UITableViewCell, TableItem, ListItemDelegatable {

    @IBOutlet private weak var actionButton: UIButton!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    
    weak var delegate: EmptyStateTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
  
    @IBAction private func handleMainAction() {
        delegate?.emptyStateTableViewCellDidPressOnAction(self)
    }
    
    func set(delegate: Delegatable) {
        self.delegate = delegate as? EmptyStateTableViewCellDelegate
    }
}

extension EmptyStateTableViewCell {
    
    static func map(data: TitleSubtitleAndValue<String>, cell: EmptyStateTableViewCell) {
        cell.titleLabel.text = data.title
        cell.subtitleLabel.text = data.subtitle
        cell.actionButton.setTitle(data.value, for: .normal)
    }
    
}
