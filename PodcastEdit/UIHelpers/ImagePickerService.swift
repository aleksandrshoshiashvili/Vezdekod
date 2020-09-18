//
//  ImagePickerService.swift
//  PodcastEdit
//
//  Created by Alexander Shoshiashvili on 16.09.2020.
//  Copyright © 2020 Илья Егоров. All rights reserved.
//

import UIKit

public protocol ImagePickerServiceDelegate: class {
    func obtainImage(image: UIImage)
}

public protocol ImagePickerServiceInput {
    var delegate: ImagePickerServiceDelegate? { get set }
    func showImagePickerDialog(withCamera isIncludeCamera: Bool,
                               library isIncludeLibrary: Bool,
                               title: String,
                               message: String,
                               viewController: UIViewController)
}

public class ImagePickerService: NSObject, ImagePickerServiceInput {
    
    fileprivate var strongSelf: ImagePickerService?
    fileprivate var imagePicker: UIImagePickerController?
    fileprivate weak var viewController: UIViewController?
    
    public weak var delegate: ImagePickerServiceDelegate?
    
    public init(viewController: UIViewController, imagePicker: UIImagePickerController = UIImagePickerController()) {
        self.viewController = viewController
        self.imagePicker = imagePicker
        super.init()
    }
    
    public func showImagePickerDialog(withCamera isIncludeCamera: Bool,
                                      library isIncludeLibrary: Bool,
                                      title: String,
                                      message: String,
                                      viewController: UIViewController) {
        self.viewController = viewController
        
        imagePicker?.delegate = self
        
        let cameraAlertAction = UIAlertAction(
            title: "Камера",
            style: .default,
            handler: { [weak self] _ in
                self?.imagePicker?.sourceType = .camera
                guard let imagePicker = self?.imagePicker else { return }
                self?.viewController?.present(imagePicker, animated: true, completion: nil)
        })
        
        let galleryAlertAction = UIAlertAction(
            title: "Галерея",
            style: .default,
            handler: { [weak self] _ in
                self?.imagePicker?.sourceType = .photoLibrary
                guard let imagePicker = self?.imagePicker else { return }
                self?.viewController?.present(imagePicker, animated: true, completion: nil)
        })
        
        let cancelAlertAction = UIAlertAction(title: "Отмена", style: .cancel)
        
        var actions: [UIAlertAction] = []
        
        if isIncludeCamera {
            actions.append(cameraAlertAction)
        }
        if isIncludeLibrary {
            actions.append(galleryAlertAction)
        }
        
        actions.append(cancelAlertAction)
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        actions.forEach({ alertController.addAction($0) })
        alertController.view.tintColor = UIColor(hex: 0x3F8AE0)
        
        self.viewController?.present(alertController, animated: true, completion: nil)
    }
    
}

extension ImagePickerService: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage {
            delegate?.obtainImage(image: image)
        } else if let image = info[.originalImage] as? UIImage {
            delegate?.obtainImage(image: image)
        } else {
            debugPrint("Something went wrong")
        }
        viewController?.dismiss(animated: true, completion: nil)
        strongSelf = nil
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        viewController?.dismiss(animated: true, completion: nil)
        strongSelf = nil
    }
    
}
