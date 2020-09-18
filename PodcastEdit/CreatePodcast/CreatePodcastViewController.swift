//
//  CreatePodcastViewController.swift
//  PodcastEdit
//
//  Created by Alexander Shoshiashvili on 16.09.2020.
//  Copyright © 2020 Илья Егоров. All rights reserved.
//

import UIKit
import SwiftyListKit

final class CreatePodcastViewController: BaseAnimatedTableViewController {
    
    enum UpdateType {
        case data
        case viewWithoutAnimation
        case viewWithAnimation
    }
    
    private lazy var vmf = CreatePosdacstVMF()
    private var settings = CreatePodcastSettings()
    
    private lazy var imageService = ImagePickerService(viewController: self)
    private lazy var nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("Далее", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17.0, weight: .medium)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad(withTableStyle: .grouped)
        
        setupView()
        
        updateData(withUpdateType: .viewWithoutAnimation)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    // MARK: - Setup
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
        tableView.backgroundColor = .systemBackground
        tableView.separatorStyle = .none
        title = "Новый подкаст"
        
        var inset = tableView.contentInset
        inset.bottom += 92
        tableView.contentInset = inset
        
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nextButton)
        NSLayoutConstraint.activate([
            nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -12),
            nextButton.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        nextButton.cornerRadius = 10
        nextButton.addTarget(self, action: #selector(handleNextAction), for: .touchUpInside)
        
        syncDelegate.didSelectRow = { [weak self] _, _, viewModel in
            guard let self = self, let tag = viewModel?.data.tag as? CreatePosdacstAction else { return }
            switch tag {
            case .link, .abnormalСontentItem, .exportItem, .trailerItem:
                self.handleAction(tag, parameter: nil)
            default:
                break
            }
        }
    }
    
    private func updateData(withUpdateType updateType: UpdateType) {
        updateNextButton()
         
        let sections = vmf.sections(settings: settings)
        
        switch updateType {
        case .viewWithAnimation:
            update(with: sections, updateAnimation: .default)
        case .viewWithoutAnimation:
            update(with: sections, updateAnimation: .noAnimations)
        case .data:
            dataSource.update(with: sections)
        }
    }
    
    private func updateNextButton() {
        if settings.isSettingsValid {
            nextButton.backgroundColor = UIColor(hex: 0x4986CC)
        } else {
            nextButton.backgroundColor = UIColor(hex: 0x4986CC).withAlphaComponent(0.4)
        }
        nextButton.isEnabled = settings.isSettingsValid
    }
    
    // MARK: - Actions
    
    @objc private func handleNextAction() {
        let identifier = NewPodcastViewController.identifier
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(identifier: identifier) as? NewPodcastViewController else { return }
        
        viewController.configure(podcast: settings)
        
        show(viewController, sender: self)
    }
    
    private func toEditAudio() {
        guard settings.isSettingsValid else {
            let alert = UIAlertController(title: "Внимание", message: "Пожалуйста, заполните основную информацию о подкасте", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true)
            return
        }
        
        let identifier = PodcastEditViewController.identifier
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(identifier: identifier) as? PodcastEditViewController else { return }
        
        viewController.configure(podcast: settings)
        
        show(viewController, sender: self)
    }
    
    private func handleAction(_ action: CreatePosdacstAction, parameter: Any?) {
        let shouldUpdateView: UpdateType
        switch action {
        case .link:
            print("handleAction -> Implement link function here")
            shouldUpdateView = .data
        case .download:
            
//            guard let url = Bundle.main.url(forResource: "Rhododendron", withExtension: "mp3") else { return }
//            let mfile = EZAudioFile(url: url)
            
//            let duration = mfile?.duration ?? 3556
//            let file = CreatePodcastSettings.File(name: "Rhododendron.mp3", time: Int(duration))
//            settings.file = file
            shouldUpdateView = .viewWithAnimation
        case .editRecord:
            toEditAudio()
            shouldUpdateView = .data
        case .abnormalСontentItem:
            settings.allowAbnormalСontent = !settings.allowAbnormalСontent
            shouldUpdateView = .viewWithAnimation
        case .exportItem:
            settings.excludeFromExport = !settings.excludeFromExport
            shouldUpdateView = .viewWithAnimation
        case .trailerItem:
            settings.trailerForPodcast = !settings.trailerForPodcast
            shouldUpdateView = .viewWithAnimation
        case .description:
            settings.descriptionText = (parameter as? String) ?? ""
            shouldUpdateView = .data
        case .nameAndIcon:
            if let text = parameter as? String {
                settings.name = text
            } else {
                imageService.showImagePickerDialog(withCamera: true,
                                                   library: true,
                                                   title: "Добавление обложки подкаста",
                                                   message: "Выберите источник изображения",
                                                   viewController: self)
                imageService.delegate = self
            }
            
            shouldUpdateView = .data
        }
        updateData(withUpdateType: shouldUpdateView)
    }
}

// MARK: - CheckboxTableViewCellDelegate

extension CreatePodcastViewController: CheckboxTableViewCellDelegate {
    func checkboxTableViewCellDidPressOnCheckbox(_ cell: CheckboxTableViewCell) {
        guard let action: CreatePosdacstAction = getTag(for: cell) else { return }
        handleAction(action, parameter: nil)
        
    }
}

// MARK: - TextViewTableViewCellDelegate

extension CreatePodcastViewController: TextViewTableViewCellDelegate {
    func textViewTableViewCell(_ cell: TextViewTableViewCell, didChangeValue newText: String) {
        guard let action: CreatePosdacstAction = getTag(for: cell) else { return }
        handleAction(action, parameter: newText)
    }
}

// MARK: - IconFieldTableViewCellDelegate

extension CreatePodcastViewController: IconFieldTableViewCellDelegate {
    func iconFieldTableViewCellDidRequestIconChange(_ cell: IconFieldTableViewCell) {
        guard let action: CreatePosdacstAction = getTag(for: cell) else { return }
        DispatchQueue.main.async {
            self.handleAction(action, parameter: nil)
        }
    }
    func iconFieldTableViewCell(_ cell: IconFieldTableViewCell, didChangeValue newText: String) {
        guard let action: CreatePosdacstAction = getTag(for: cell) else { return }
        handleAction(action, parameter: newText)
    }
}

// MARK: - ImagePickerServiceDelegate

extension CreatePodcastViewController: ImagePickerServiceDelegate {
    func obtainImage(image: UIImage) {
        settings.icon = image
        DispatchQueue.main.async {
            self.updateData(withUpdateType: .viewWithoutAnimation)
        }
    }
}

// MARK: - EmptyStateTableViewCellDelegate

extension CreatePodcastViewController: EmptyStateTableViewCellDelegate {
    func emptyStateTableViewCellDidPressOnAction(_ cell: EmptyStateTableViewCell) {
        guard let action: CreatePosdacstAction = getTag(for: cell) else { return }
        handleAction(action, parameter: nil)
    }
}

// MARK: - FileTableViewCellDelegate

extension CreatePodcastViewController: FileTableViewCellDelegate {
    func fileTableViewCellDidPressOnAction(_ cell: FileTableViewCell) {
        guard let action: CreatePosdacstAction = getTag(for: cell) else { return }
        handleAction(action, parameter: nil)
    }
}
