//
//  AddTimeCodeView.swift
//  PodcastEdit
//
//  Created by Илья Егоров on 16.09.2020.
//  Copyright © 2020 Илья Егоров. All rights reserved.
//

import UIKit

struct TimeCode {
    var name: String
    var time: Int = 0
}

final class AddTimeCodeView: UIView {

    @IBOutlet private weak var removeTimeCodeButton: UIButton!
    @IBOutlet private weak var nameTextView: UITextView!
    @IBOutlet private weak var timeTextView: UITextView!
    
    @IBAction private func didTapDelete(_ sender: UIButton) {
        endEditing(true)
        removeFromSuperview()
    }
    
    var timeCode: TimeCode? {
        if currentText.isEmpty || currentTime < 0 {
            return nil
        }
        return TimeCode(name: currentText, time: currentTime)
    }
    
    private let namePlaceholder = "Название таймкода"
    private let timePlaceholder = "00:00"
    
    private var currentText = ""
    var currentTime = -1 {
        didSet {
            timeTextView.text = currentTime.timeString
            timeTextView.textColor = .black
        }
    }
    
    func configure(maxLength: Int) {
        let timePicker = TimeDatePicker()
        timePicker.configure(maxLength: maxLength) { [weak self] newTime in
            self?.currentTime = min(newTime, maxLength)
        }
        timeTextView.inputView = timePicker
        
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = .vkBlueTintColor
        toolBar.sizeToFit()

        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

        let doneButton = UIBarButtonItem(title: "Готово", style: .plain, target: self, action: #selector(resign))
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true

        timeTextView.inputAccessoryView = toolBar
    }
    
    @objc private func resign() {
        timeTextView.resignFirstResponder()
    }
}

extension AddTimeCodeView: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView === nameTextView {
            if currentText.isEmpty {
                textView.text = nil
                textView.textColor = .black
            }
            return
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView === nameTextView {
            if currentText.isEmpty {
                textView.text = namePlaceholder
                textView.textColor = .lightGrayCaptionColor
            }
            return
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView === nameTextView {
            currentText = textView.text
            return
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n" {
            textView.endEditing(true)
            return false
        }
        return textView === nameTextView
    }
}
