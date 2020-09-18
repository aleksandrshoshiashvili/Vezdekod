//
//  NewPodcastViewController.swift
//  PodcastEdit
//
//  Created by Илья Егоров on 17.09.2020.
//  Copyright © 2020 Илья Егоров. All rights reserved.
//

import UIKit

final class NewPodcastViewController: UIViewController {

    static var identifier: String { String(describing: self) }
    
    @IBOutlet private weak var podcastImageView: UIImageView!
    @IBOutlet private weak var podcastTitleLabel: UILabel!
    @IBOutlet private weak var podcastDurationLabel: UILabel!
    @IBOutlet private weak var podcastDescriptionLabel: UILabel!


    @IBOutlet private weak var timeCodeStackView: UIStackView!

    private var podcast: CreatePodcastSettings!
    private var timeCodes: [TimeCode]!

    func configure(podcast: CreatePodcastSettings, timeCodes: [TimeCode] = []) {
        self.podcast = podcast
        self.timeCodes = timeCodes
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setup()
    }
    
    private func setup() {
        podcastImageView.image = podcast.icon
        podcastTitleLabel.text = podcast.name
        if let time = podcast.file?.time {
            podcastDurationLabel.text = "Длительность: \(time.timeString)"
        } else {
            podcastDurationLabel.text = nil
        }
        podcastDescriptionLabel.text = podcast.descriptionText
        
        if timeCodes.isEmpty {
            timeCodeStackView.isHidden = true
        } else {
            for timeCode in timeCodes.sorted(by: { $0.time <= $1.time }) {
                guard let timeCodeView = Bundle.main
                    .loadNibNamed(String(describing: TimeCodeView.self), owner: self, options: nil)?
                    .compactMap({ $0 as? TimeCodeView })
                    .first else { return }
                timeCodeView.configure(timecode: timeCode, didTapCode: {
                    debugPrint("Перемотка на воспроизведение с участка \(timeCode.time.timeString)")
                })
                timeCodeStackView.insertArrangedSubview(timeCodeView, at: 2)
            }
        }
    }
    
    @IBAction func back(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
