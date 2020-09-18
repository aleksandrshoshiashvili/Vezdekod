//
//  FIleTableViewCell.swift
//  PodcastEdit
//
//  Created by Alexander Shoshiashvili on 16.09.2020.
//  Copyright © 2020 Илья Егоров. All rights reserved.
//

import UIKit
import SwiftyListKit

protocol FileTableViewCellDelegate: Delegatable {
    func fileTableViewCellDidPressOnAction(_ cell: FileTableViewCell)
}

final class FileTableViewCell: UITableViewCell, TableItem, ListItemDelegatable {

    @IBOutlet private weak var actionButton: UIButton!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var timeCodeLabel: UILabel!
    @IBOutlet private weak var infoLabel: UILabel!
    
    weak var delegate: FileTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
  
    @IBAction private func handleMainAction() {
        delegate?.fileTableViewCellDidPressOnAction(self)
    }
    
    func set(delegate: Delegatable) {
        self.delegate = delegate as? FileTableViewCellDelegate
    }
}

extension FileTableViewCell {
    
    static func map(data: TitleSubtitleAndValue<String>, cell: FileTableViewCell) {
        cell.titleLabel.text = data.title
        cell.timeCodeLabel.text = data.subtitle
        cell.infoLabel.text = data.value
    }
    
}
