//
//  MapPinView.swift
//  PodcastEdit
//
//  Created by Alexander Shoshiashvili on 19.09.20.
//  Copyright © 2020 Илья Егоров. All rights reserved.
//

import UIKit

final class MapPinView: UIView, NibLoadable {

    @IBOutlet weak var roundedView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        layer.shadowColor = UIColor.black.withAlphaComponent(0.08).cgColor
        layer.shadowOpacity = 1.0
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 12.0
        backgroundColor = .clear
    }

}
