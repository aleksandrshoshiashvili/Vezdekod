//
//  GenericCollectionContainerView.swift
//  PodcastEdit
//
//  Created by Alexander Shoshiashvili on 18.09.20.
//  Copyright © 2020 Илья Егоров. All rights reserved.
//

import UIKit
import SwiftyListKit

final class GenericCollectionContainerView: UIView, AnimatedCollectionListProtocol {

    var dataSource: CollectionViewDataSourceAnimated<CollectionListSection>!
    var syncDelegate: CollectionViewDelegate<CollectionListSection>!
    var collectionView: UICollectionView!


}
