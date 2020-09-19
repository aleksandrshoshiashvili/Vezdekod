//
//  SelectorView.swift
//  PodcastEdit
//
//  Created by Alexander Shoshiashvili on 18.09.2020.
//  Copyright © 2020 Илья Егоров. All rights reserved.
//

import UIKit

protocol SelectorViewDelegate: AnyObject {
    func selectorViewDidPressed(_ view: SelectorView)
}

final class SelectorView: UIView, NibOwnerLoadable {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var arrowButton: UIButton!

    private let generator = UIImpactFeedbackGenerator(style: .medium)

    weak var delegate: SelectorViewDelegate?

    required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
      self.loadNibContent()
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        layer.shadowColor = UIColor.black.withAlphaComponent(0.08).cgColor
        layer.shadowOpacity = 1.0
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 12.0

        containerView.layer.cornerRadius = 10
        containerView.layer.masksToBounds = true
        backgroundColor = .clear

        arrowButton.isUserInteractionEnabled = false
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapAction))
        addGestureRecognizer(tap)
    }

    // MARK: - Actions

    @objc private func handleTapAction() {
        delegate?.selectorViewDidPressed(self)
        impactOccurred()
        UIView.animate(withDuration: 0.15, animations:  {
          let scale: CGFloat = 0.9
          self.transform = CGAffineTransform(scaleX: scale, y: scale)
        }, completion: { _ in
            UIView.animate(withDuration: 0.15, animations:  {
                self.transform =  .identity
            })
        })
    }

    @IBAction private func handleArrowAction() {
        delegate?.selectorViewDidPressed(self)
        impactOccurred()
    }

    private func impactOccurred() {
        generator.prepare()
        generator.impactOccurred()
    }
}
