//
//  IconFieldTableViewCell.swift
//  PodcastEdit
//
//  Created by Alexander Shoshiashvili on 16.09.2020.
//  Copyright © 2020 Илья Егоров. All rights reserved.
//

import UIKit
import SwiftyListKit

protocol IconFieldTableViewCellDelegate: Delegatable {
    func iconFieldTableViewCell(_ cell: IconFieldTableViewCell, didChangeValue newText: String)
    func iconFieldTableViewCellDidRequestIconChange(_ cell: IconFieldTableViewCell)
}

final class IconFieldTableViewCell: UITableViewCell, TableItem, ListItemDelegatable {

    @IBOutlet private weak var iconButton: UIButton!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var textField: TextField!
    
    weak var delegate: IconFieldTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        textField.delegate = self
        textField.addDoneButton(title: "Готово", target: self, selector: #selector(tapDone))
    }
    
    @objc func tapDone(sender: Any) {
        self.textField.resignFirstResponder()
    }
    
    @IBAction private func handleIconAction() {
        delegate?.iconFieldTableViewCellDidRequestIconChange(self)
    }
    
    func set(delegate: Delegatable) {
        self.delegate = delegate as? IconFieldTableViewCellDelegate
    }
}

extension IconFieldTableViewCell: UITextFieldDelegate {
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        let text: NSString = (textField.text ?? "") as NSString
        let resultString = text.replacingCharacters(in: range, with: string)
        delegate?.iconFieldTableViewCell(self, didChangeValue: resultString)
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.borderColor = UIColor(hex: 0x3F8AE0)
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.12)
    }
}

extension IconFieldTableViewCell {
    
    static func map(data: TextValueIcon<String>, cell: IconFieldTableViewCell) {
        cell.titleLabel.text = data.title
        cell.textField.text = data.value
        cell.iconButton.setImage(data.icon, for: .normal)
    }
    
}

extension UITextField {

    func addDoneButton(title: String, target: Any, selector: Selector) {

        let toolBar = UIToolbar(frame: CGRect(x: 0.0,
                                              y: 0.0,
                                              width: UIScreen.main.bounds.size.width,
                                              height: 44.0))//1
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let barButton = UIBarButtonItem(title: title, style: .plain, target: target, action: selector)
        toolBar.setItems([flexible, barButton], animated: false)
        self.inputAccessoryView = toolBar
    }
}
