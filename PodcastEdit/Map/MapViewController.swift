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

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var searchShadowContainerView: UIView!
    @IBOutlet weak var searchContainerView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionContainer: GenericCollectionContainerView!
    @IBOutlet weak var selectorView: SelectorView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var filterContainerBottomConstraint: NSLayoutConstraint!

    private let generator = UIImpactFeedbackGenerator(style: .medium)
    private lazy var emojiFiltersVMF: EmojiFiltersVMFProtocol = EmojiFiltersVMF()
    private lazy var service: EmojiesService = .init()
    private var selectedFilters: [EmojiFilter] = []
    private var allFilters: [EmojiFilter] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        let filters = service.getEmojiFilters()
        self.allFilters = filters
        updateView(filters: filters)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    // MARK: - Setup

    private func setupView() {
        searchShadowContainerView.layer.shadowColor = UIColor.black.withAlphaComponent(0.08).cgColor
        searchShadowContainerView.layer.shadowOpacity = 1.0
        searchShadowContainerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        searchShadowContainerView.layer.shadowRadius = 12.0

        searchContainerView.layer.cornerRadius = 10
        searchContainerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        searchContainerView.layer.masksToBounds = true

        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 8
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        layout.itemSize = CGSize(width: 64, height: 84)
        collectionContainer.setup(withLayout: layout)
        collectionContainer.collectionView.showsHorizontalScrollIndicator = false

        searchBar.searchBarStyle = .minimal
        searchBar.delegate = self

        setupMap()
    }

    private func setupMap() {
        mapView.setCenter(.init(latitude: 55.7558, longitude: 37.6173), animated: true)
    }

    // MARK: - Update

    private func updateView(filters: [EmojiFilter]) {
        let sections = emojiFiltersVMF.sections(filters: filters, selected: selectedFilters)
        collectionContainer.update(with: sections)
    }

    // MARK: - Actions

    @IBAction private func handleCloseAction() {
        generator.prepare()
        generator.impactOccurred()
        navigationController?.popViewController(animated: true)
    }

    @objc fileprivate func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            filterContainerBottomConstraint.constant = keyboardSize.height
            UIView.animate(withDuration: 0.3, animations: { self.view.layoutIfNeeded() })
        }
    }

    @objc fileprivate func keyboardWillHide(notification: Notification) {
        filterContainerBottomConstraint.constant = 0
        UIView.animate(withDuration: 0.3, animations: { self.view.layoutIfNeeded() })
    }

}

// MARK: -

extension MapViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let filters = searchText.isEmpty ? allFilters : allFilters.filter({ $0.title.contains(searchText) })
        updateView(filters: filters)
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
