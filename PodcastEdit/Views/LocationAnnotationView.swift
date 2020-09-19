//
//  LocationAnnotationView.swift
//  PodcastEdit
//
//  Created by Alexander Shoshiashvili on 19.09.20.
//  Copyright © 2020 Илья Егоров. All rights reserved.
//

import UIKit
import MapKit

final class LocationAnnotationView: MKAnnotationView, Reusable {

    // MARK: Initialization

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)

        frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        centerOffset = CGPoint(x: 0, y: -frame.size.height / 2)

        canShowCallout = false
        setupUI()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Setup

    private func setupUI() {
        backgroundColor = .clear

        let view = MapPinView.loadFromNib()
        view.titleLabel.text = annotation?.subtitle ?? ""
        view.subtitleLabel.text = annotation?.title ?? ""
        addSubview(view)
        view.frame = bounds
        view.roundedView.cornerRadius = bounds.height / 2.0
    }
}
