//
//  AnimatedCollectionListProtocol.swift
//  DifferenceKit
//
//  Created by Alexander Shoshiashvili on 01.07.2020.
//

import UIKit

public protocol AnimatedCollectionListProtocol: CreateCollectionProtocol, UpdateCollectionProtocol, Delegatable {
    
    var collectionView: UICollectionView! { get set }
    var dataSource: CollectionViewDataSourceAnimated<CollectionListSection>! { get set }
    var syncDelegate: CollectionViewDelegate<CollectionListSection>! { get set }
    
    func setup(withLayout layout: UICollectionViewLayout)
    func setupCollectionViewRepresentation()
    func update(with sections: [CollectionListSection])

    func getTag<T>(for cell: UICollectionViewCell) -> T?
}

public extension AnimatedCollectionListProtocol {
    func setup(withLayout layout: UICollectionViewLayout) {
        createAndSetupCollectionView(with: layout)
        setupCollectionViewRepresentation()
    }
    
    func setupCollectionViewRepresentation() {
        if #available(iOS 13.0, *) {
            collectionView.backgroundColor = .systemBackground
        } else {
            collectionView.backgroundColor = .white
        }
    }
    
    func clearData() {
        dataSource.setSections([])
        update(with: [])
    }
    
    func update(with sections: [CollectionListSection]) {
        update(with: sections, updateAnimation: .default)
    }

    func update(with sections: [CollectionListSection], updateAnimation: CollectionListUpdateAnimation) {
        ListUpdater.updateCollectionViewView(collectionView,
                                             with: dataSource,
                                             newSections: sections,
                                             updateAnimation: updateAnimation)
    }
    
    func showLoader() {
        collectionView.showLoader(loaderType: .solid(config: .default))
    }
    
    func showLoader(with sections: [CollectionListSection]) {
        collectionView.isHidden = true
        update(with: sections)
        
        let delay = 0.1
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.collectionView.showLoader(loaderType: .solid(config: .default))
        }
    }
    
    func hideLoader() {
        collectionView.hideLoader()
    }
    
    func hideLoader(with replacingSections: [CollectionListSection]) {
        update(with: replacingSections)
        collectionView.hideLoader()
    }
    
    func setDefaultDataSource() {
        let dataSource = CollectionViewDataSourceAnimated<CollectionListSection>()
        setDataSource(dataSource)
    }
    
    func setDataSource(_ dataSource: CollectionViewDataSourceAnimated<CollectionListSection>) {
        self.dataSource = dataSource
        self.syncDelegate = CollectionViewDelegate(dataSource: dataSource)
        collectionView.dataSource = dataSource
        collectionView.delegate = syncDelegate
        dataSource.delegate = self
    }

    func getTag<T>(for cell: UICollectionViewCell) -> T? {
        guard let indexPath = collectionView.indexPath(for: cell),
            let viewModel = dataSource.getViewModel(for: indexPath),
            let tag = viewModel.data.tag as? T else {
                return nil
        }
        return tag
    }
}
