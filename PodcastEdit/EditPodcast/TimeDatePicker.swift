//
//  TimeDatePicker.swift
//  PodcastEdit
//
//  Created by Илья Егоров on 17.09.2020.
//  Copyright © 2020 Илья Егоров. All rights reserved.
//

import UIKit

final class TimeDatePicker: UIPickerView {

    private var hours: Int = 0
    private var minutes: Int = 0
    private var seconds: Int = 0
    
    private var currentTime: Int {
        return seconds + minutes * 60 + hours * 3600
    }
    
    private var maxSeconds: Int!
    private var hasHours: Bool { maxSeconds >= 3600 }
    
    private var onDidChange: ((Int) -> Void)!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(maxLength: Int, currentTime: Int = 0, onDidChange: @escaping (Int) -> Void) {
        maxSeconds = maxLength
        self.hours = currentTime / 3600
        self.minutes = (currentTime % 3600) / 60
        self.seconds = currentTime % 60
        self.onDidChange = onDidChange
    }
}

extension TimeDatePicker: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return hasHours ? 3 : 2
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if hasHours {
            switch component {
            case 0:
                return 25
            case 1, 2:
                return 60
            default:
                return 0
            }
        } else {
            switch component {
            case 0, 1:
                return 60
            default:
                return 0
            }
        }
    }

    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return pickerView.frame.size.width / (hasHours ? 3 : 2)
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(format: "%02d", row)
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if hasHours {
            switch component {
            case 0:
                hours = row
            case 1:
                minutes = row
            case 2:
                seconds = row
            default:
                break
            }
        } else {
            switch component {
            case 0:
                minutes = row
            case 1:
                seconds = row
            default:
                break
            }
        }
        onDidChange(currentTime)
    }
}

