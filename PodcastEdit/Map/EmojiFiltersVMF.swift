//
//  EmojiFiltersVMF.swift
//  PodcastEdit
//
//  Created by Alexander Shoshiashvili on 18.09.20.
//  Copyright © 2020 Илья Егоров. All rights reserved.
//

import UIKit
import SwiftyListKit

protocol EmojiFiltersVMFProtocol {
    func sections(filters: [EmojiFilter], selected: [EmojiFilter]) -> [CollectionListSection]
}

struct EmojiFiltersVMF: EmojiFiltersVMFProtocol {

    func sections(filters: [EmojiFilter], selected: [EmojiFilter]) -> [CollectionListSection] {
        let viewModels = filters.map(getFilterComponent)
        let section = CollectionListSection(rows: viewModels)
        return [section]
    }

    // MARK: - Private

    private func getFilterComponent(filter: EmojiFilter) -> CollectionItemViewModel {
        let data = TitleSubtitleAndValue(tag: filter.id, title: filter.title,
                                         subtitle: filter.emoji,
                                         value: filter.category.value)
        let item = CollectionItemViewModel(data: data,
                                           map: EmojiFilterCollectionViewCell.map,
                                           heightStyle: .static(height: 84, width: 64))
        return item
    }

}

