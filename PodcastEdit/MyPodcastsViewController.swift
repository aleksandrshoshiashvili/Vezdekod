//
//  MyPodcastsViewController.swift
//  PodcastEdit
//
//  Created by Илья Егоров on 16.09.2020.
//  Copyright © 2020 Илья Егоров. All rights reserved.
//

import UIKit

final class MyPodcastsViewController: UIViewController {

    @IBAction func didTapCreate() {
        navigationController?.pushViewController(CreatePodcastViewController(), animated: true)
    }
}

