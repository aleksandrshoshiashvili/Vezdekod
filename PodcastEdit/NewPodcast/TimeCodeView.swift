//
//  TimeCodeView.swift
//  PodcastEdit
//
//  Created by Илья Егоров on 17.09.2020.
//  Copyright © 2020 Илья Егоров. All rights reserved.
//

import UIKit

final class TimeCodeView: UIView {

    @IBOutlet private weak var timeButton: UIButton!
    @IBOutlet private weak var nameLabel: UILabel!
    
    private var didTapCode: (() -> Void)!
    
    func configure(timecode: TimeCode, didTapCode: @escaping () -> Void) {
        self.didTapCode = didTapCode
        
        timeButton.setTitle(timecode.time.timeString, for: .normal)
        timeButton.addTarget(self, action: #selector(didTapToTimeCode(_:)), for: .touchUpInside)
        
        nameLabel.text = timecode.name
    }
    
    @objc private func didTapToTimeCode(_ sender: Any) {
        didTapCode()
    }

}
