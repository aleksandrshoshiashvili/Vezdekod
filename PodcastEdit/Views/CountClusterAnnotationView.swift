//
//  CountClusterAnnotationView.swift
//  PodcastEdit
//
//  Created by Alexander Shoshiashvili on 19.09.20.
//  Copyright © 2020 Илья Егоров. All rights reserved.
//

import UIKit
import Cluster

class CountClusterAnnotationView: StyledClusterAnnotationView {
    override func configure() {
        super.configure()

        self.layer.cornerRadius = self.frame.width / 2
        self.layer.masksToBounds = true
        self.layer.borderColor = UIColor.systemBackground.cgColor
        countLabel.textColor = .label
    }
}
