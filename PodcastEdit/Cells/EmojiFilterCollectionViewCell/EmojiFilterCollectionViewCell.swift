//
//  EmojiFilterCollectionViewCell.swift
//  PodcastEdit
//
//  Created by Alexander Shoshiashvili on 18.09.20.
//  Copyright © 2020 Илья Егоров. All rights reserved.
//

import UIKit
import SwiftyListKit

final class EmojiFilterCollectionViewCell: UICollectionViewCell, CollectionItem {

    @IBOutlet private weak var categoryRoundedView: UIView!
    @IBOutlet private weak var categoryContainerView: UIView!
    @IBOutlet private weak var emojiContainerView: UIView!
    @IBOutlet private weak var emojiLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var categoryLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        categoryContainerView.layer.shadowColor = UIColor.black.withAlphaComponent(0.08).cgColor
        categoryContainerView.layer.shadowOpacity = 1.0
        categoryContainerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        categoryContainerView.layer.shadowRadius = 2.0

        categoryRoundedView.layer.borderWidth = 0.5
        emojiContainerView.layer.borderWidth = 0.5
    }
}

extension EmojiFilterCollectionViewCell {

    static func map(data: TitleSubtitleAndValue<String>, cell: EmojiFilterCollectionViewCell) {
        cell.titleLabel.text = data.title
        cell.emojiLabel.text = data.subtitle
        cell.categoryLabel.text = data.value
    }

}

extension ListItemStyle where T: EmojiFilterCollectionViewCell {
    static var selected: ListItemStyle<T> {
        return ListItemStyle<T> {
            $0.backgroundColor = .red
        }
    }
}
