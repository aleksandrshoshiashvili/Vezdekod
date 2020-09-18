//
//  MapViewController.swift
//  PodcastEdit
//
//  Created by Alexander Shoshiashvili on 18.09.2020.
//  Copyright © 2020 Илья Егоров. All rights reserved.
//

import UIKit
import MapKit

final class MapViewController: UIViewController {
    
    @IBOutlet weak var selectorView: SelectorView!
    @IBOutlet weak var closeButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    // MARK: - Actions

    @IBAction private func handleCloseAction() {
        
    }

}
