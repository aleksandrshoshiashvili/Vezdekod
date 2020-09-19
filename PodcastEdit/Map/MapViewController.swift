//
//  MapViewController.swift
//  PodcastEdit
//
//  Created by Alexander Shoshiashvili on 18.09.2020.
//  Copyright © 2020 Илья Егоров. All rights reserved.
//

import UIKit
import MapKit
import Cluster

final class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var searchShadowContainerView: UIView!
    @IBOutlet weak var searchContainerView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionContainer: GenericCollectionContainerView!
    @IBOutlet weak var selectorView: SelectorView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var filterContainerBottomConstraint: NSLayoutConstraint!

    lazy var manager: ClusterManager = { [unowned self] in
        let manager = ClusterManager()
        manager.delegate = self
        manager.maxZoomLevel = 14
        manager.minCountForClustering = 3
        manager.clusterPosition = .nearCenter
        return manager
    }()
    private let generator = UIImpactFeedbackGenerator(style: .medium)
    private lazy var emojiFiltersVMF: EmojiFiltersVMFProtocol = EmojiFiltersVMF()
    private lazy var service: EmojiesService = .init()
    private var selectedFilters: [EmojiFilter] = []
    private var allFilters: [EmojiFilter] = []
    private var allAnnotations: [Annotation] = []
    private var currentSearch: String = ""

    private let region = (center: CLLocationCoordinate2D(latitude: 55.7558, longitude: 37.6173), delta: 0.8)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        let filters = service.getEmojiFilters()
        self.allFilters = filters
        self.allAnnotations = getAllAnnotations()
        updateView()

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
        collectionContainer.syncDelegate.didSelectItem = { [weak self] _, _, viewModel in
            guard let self = self, let tag = viewModel?.data.tag as? String else { return }
            if let index = self.selectedFilters.firstIndex(where: { $0.id == tag }) {
                self.selectedFilters.remove(at: index)
            } else if let filter = self.allFilters.first(where: { $0.id == tag }) {
                self.selectedFilters.append(filter)
            }
            self.updateView()
        }

        searchBar.searchBarStyle = .minimal
        searchBar.delegate = self

        selectorView.delegate = self

        setupMap()
    }

    private func setupMap() {
        mapView.setCenter(.init(latitude: 55.7558, longitude: 37.6173), animated: true)
        mapView.delegate = self
    }

    // MARK: - Update

    private func updateView() {
        let filters = currentSearch.isEmpty ? allFilters : allFilters.filter({ $0.title.contains(currentSearch) })
        let sections = emojiFiltersVMF.sections(filters: filters, selected: selectedFilters)
        collectionContainer.update(with: sections)
        updateAnnotations(filters: selectedFilters.isEmpty ? allFilters : selectedFilters)
    }

    private func updateAnnotations(filters: [EmojiFilter]) {
        manager.removeAll()
        let annotations = allAnnotations.filter { (annotation) -> Bool in
            return filters.contains(where: { $0.title == annotation.title })
        }
        manager.add(annotations)
        manager.reload(mapView: mapView)
    }

    private func getAllAnnotations() -> [Annotation] {
        let countRange = (0..<allFilters.count * 50)
        let annotations = countRange.map({ _ -> Annotation in
            let annotation = Annotation()
            let lat = region.center.latitude + drand48() * region.delta - region.delta / 2
            let long = region.center.longitude + drand48() * region.delta - region.delta / 2
            annotation.coordinate = CLLocationCoordinate2D(latitude: lat,
                                                           longitude: long)
            let currentElement = self.allFilters.randomElement()
            annotation.title = currentElement?.title
            annotation.subtitle = currentElement?.emoji
            return annotation
        })
        return annotations
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

// MARK: - UISearchBarDelegate

extension MapViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        currentSearch = searchText
        updateView()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

// MARK: - MKMapViewDelegate

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? ClusterAnnotation {
            return CountClusterAnnotationView(annotation: annotation, reuseIdentifier: "cluster", style: .color(.systemBackground, radius: 30))
        } else {
            return LocationAnnotationView(annotation: annotation, reuseIdentifier: "pin")
        }
    }

    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        manager.reload(mapView: mapView) { _ in }
    }

    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        views.forEach { $0.alpha = 0 }
        UIView.animate(withDuration: 0.35, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: [], animations: {
            views.forEach { $0.alpha = 1 }
        }, completion: nil)
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard view is LocationAnnotationView else { return }
        let vc = UIStoryboard(name: "FeedViewControllers", bundle: nil)
            .instantiateInitialViewController() as! FeedViewControllers
        vc.isDetailsMode = true
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - ClusterManagerDelegate

extension MapViewController: ClusterManagerDelegate {
    func cellSize(for zoomLevel: Double) -> Double? {
        switch zoomLevel {
        case 0..<10:
            return 200
        case 10..<11:
            return 140
        case 11..<12:
            return 100
        default:
            return 88
        }
    }
}

// MARK: - SelectorViewDelegate

extension MapViewController: SelectorViewDelegate {
    func selectorViewDidPressed(_ view: SelectorView) {
        let alert = UIAlertController(title: "Выберите фильтр по настроению", message: nil, preferredStyle: .actionSheet)

        EmojiFilter.Category.allCases.forEach({ (category) in
            let action = UIAlertAction(title: category.fullDescription, style: .default, handler: { [weak self] _ in
                guard let self = self else { return }
                self.selectedFilters.removeAll()
                let filtered = self.allFilters.filter({ $0.category == category })
                self.selectedFilters.append(contentsOf: filtered)
                self.selectorView.titleLabel.text = category.fullDescription
                self.updateView()
            })
            alert.addAction(action)
        })

        let action = UIAlertAction(title: "Все категории", style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            self.selectedFilters.removeAll()
            self.selectorView.titleLabel.text = "Все категории"
            self.updateView()
        })
        alert.addAction(action)

        let cancel = UIAlertAction(title: "Отмена", style: .cancel, handler: { _ in })
        alert.addAction(cancel)

        alert.view.tintColor = .label

        present(alert, animated: true, completion: nil)
    }
}
