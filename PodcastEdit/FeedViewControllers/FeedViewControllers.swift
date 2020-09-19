//
//  FeedViewControllers.swift
//  PodcastEdit
//
//  Created by Alexander Shoshiashvili on 19.09.20.
//  Copyright © 2020 Илья Егоров. All rights reserved.
//

import UIKit

final class FeedViewControllers: UIViewController {

    @IBOutlet weak var feedImageView: UIImageView!

    var isDetailsMode: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        feedImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapAction))
        feedImageView.addGestureRecognizer(tap)

        if isDetailsMode {
            feedImageView.image = UIImage(named: "feed")
        } else {
            feedImageView.image = UIImage(named: "feedInitial")
        }
    }

    @objc private func handleTapAction() {
        if !isDetailsMode {
            let vc = UIStoryboard(name: "MapViewController", bundle: nil).instantiateInitialViewController()!
            navigationController?.pushViewController(vc, animated: true)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }

}
