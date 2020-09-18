//
//  CheckboxTableViewCell.swift
//  PodcastEdit
//
//  Created by Alexander Shoshiashvili on 16.09.2020.
//  Copyright © 2020 Илья Егоров. All rights reserved.
//

import UIKit
import SwiftyListKit

protocol CheckboxTableViewCellDelegate: Delegatable {
    func checkboxTableViewCellDidPressOnCheckbox(_ cell: CheckboxTableViewCell)
}

final class CheckboxTableViewCell: UITableViewCell, TableItem, ListItemDelegatable {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var checkboxButton: UIButton!
    
    weak var delegate: CheckboxTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    func set(delegate: Delegatable) {
        self.delegate = delegate as? CheckboxTableViewCellDelegate
    }
    
    @IBAction func handleCheckboxAction() {
        delegate?.checkboxTableViewCellDidPressOnCheckbox(self)
    }
}

extension CheckboxTableViewCell {
    
    static func map(data: TextAndValue<Bool>, cell: CheckboxTableViewCell) {
        cell.titleLabel.text = data.title
        
        if data.value {
            cell.checkboxButton.setImage(UIImage(named: "selectedCheckbox"), for: .normal)
        } else {
            cell.checkboxButton.setImage(UIImage(named: "checkbox"), for: .normal)
        }
    }
    
}
