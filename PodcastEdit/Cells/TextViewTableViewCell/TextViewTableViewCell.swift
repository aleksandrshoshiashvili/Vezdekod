//
//  TextViewTableViewCell.swift
//  PodcastEdit
//
//  Created by Alexander Shoshiashvili on 16.09.2020.
//  Copyright © 2020 Илья Егоров. All rights reserved.
//

import UIKit
import SwiftyListKit

protocol TextViewTableViewCellDelegate: Delegatable {
    func textViewTableViewCell(_ cell: TextViewTableViewCell, didChangeValue newText: String)
}

final class TextViewTableViewCell: UITableViewCell, TableItem, ListItemDelegatable {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var textView: UITextView!
    
    weak var delegate: TextViewTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        textView.delegate = self
        textView.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        textView.addDoneButton(title: "Готово", target: self, selector: #selector(tapDone))
    }
    
    @objc func tapDone(sender: Any) {
        self.textView.resignFirstResponder()
    }
    
    func set(delegate: Delegatable) {
        self.delegate = delegate as? TextViewTableViewCellDelegate
    }
}

extension TextViewTableViewCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        delegate?.textViewTableViewCell(self, didChangeValue: textView.text)
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        textView.borderColor = UIColor(hex: 0x3F8AE0)
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.12)
    }
}

extension TextViewTableViewCell {
    
    static func map(data: TextAndValue<String>, cell: TextViewTableViewCell) {
        cell.titleLabel.text = data.title
        cell.textView.text = data.value
    }
    
}

extension UITextView {

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
