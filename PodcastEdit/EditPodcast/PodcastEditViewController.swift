//
//  PodcastEditViewController.swift
//  PodcastEdit
//
//  Created by Илья Егоров on 16.09.2020.
//  Copyright © 2020 Илья Егоров. All rights reserved.
//

import UIKit
import AVFoundation
import SnapKit

final class PodcastEditViewController: UIViewController {
    
    static var identifier: String { String(describing: self) }
    
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var playButton: UIButton!

    
//    @IBOutlet private weak var waveFormView: EZAudioPlot!
    
//    private var player: EZAudioPlayer?

    private var podcast: CreatePodcastSettings!
    
    private var isPlaying = false
    
    func configure(podcast: CreatePodcastSettings) {
        self.podcast = podcast
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupWaveForm()
    }
    
    private func setupWaveForm() {
//        guard let url = Bundle.main.url(forResource: "Rhododendron", withExtension: "mp3") else { return }
//        let file = EZAudioFile(url: url)
//        guard let data = file?.getWaveformData() else { return }
//
//        waveFormView.plotType = .rolling
//        waveFormView.shouldFill = true
//        waveFormView.shouldMirror = true
//        waveFormView.color = .vkBlueTintColor
//        waveFormView.updateBuffer( data.buffers[0], withBufferSize: data.bufferSize )
//        guard let duration = file?.duration else { return }
//        waveFormView.snp.makeConstraints {
//            $0.width.equalTo(duration * 8)
//        }
    }
    
    @IBAction func back(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTapPlay(_ sender: UIButton) {
        view.endEditing(true)

//        isPlaying.toggle()
//        let image = isPlaying ? #imageLiteral(resourceName: "pause_48") : #imageLiteral(resourceName: "icon_play")
//        sender.setImage(image, for: .normal)
//
//        if isPlaying {
//
//
//            guard let url = Bundle.main.url(forResource: "Rhododendron", withExtension: "mp3") else { return }
//            if player == nil {
//                do {
//                    try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
//                    try AVAudioSession.sharedInstance().setActive(true)
//                } catch {
//
//                }
//                player = EZAudioPlayer(audioFile: EZAudioFile(url: url), delegate: self)
//            }
//            player?.play()
//        } else {
//            player?.pause()
//        }
    }
    
    @IBAction func didTapAddTimecode(_ sender: UIButton) {
        guard let index = stackView.arrangedSubviews.firstIndex(of: sender) else { return }
        
         guard let timeCodeView = Bundle.main
            .loadNibNamed(String(describing: AddTimeCodeView.self), owner: self, options: nil)?
            .compactMap({ $0 as? AddTimeCodeView })
            .first else { return }
        
        if let podcastTime = podcast.file?.time {
            timeCodeView.configure(maxLength: podcastTime)
        }
        stackView.insertArrangedSubview(timeCodeView, at: index)
    }
    
    @IBAction func didTapToBeginning(_ sender: UIButton) {
//        waveFormView.clear()
//        player?.seek(toFrame: 0)
    }
    
    @IBAction func didTapNext(_ sender: Any) {
        view.endEditing(true)
        
        let identifier = NewPodcastViewController.identifier
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(identifier: identifier) as? NewPodcastViewController else { return }
        
        let timeCodes = stackView.arrangedSubviews
            .compactMap({ ($0 as? AddTimeCodeView)?.timeCode })
        
        viewController.configure(podcast: podcast, timeCodes: timeCodes)
        
        show(viewController, sender: self)
    }
}

extension PodcastEditViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
}

//extension PodcastEditViewController: EZAudioPlayerDelegate {
//    func audioPlayer(_ audioPlayer: EZAudioPlayer!, playedAudio buffer: UnsafeMutablePointer<UnsafeMutablePointer<Float>?>!, withBufferSize bufferSize: UInt32, withNumberOfChannels numberOfChannels: UInt32, in audioFile: EZAudioFile!) {
//
//        DispatchQueue.main.async { [weak self] in
//            self?.waveFormView.updateBuffer(buffer[0], withBufferSize: bufferSize)
//        }
//    }
//}
