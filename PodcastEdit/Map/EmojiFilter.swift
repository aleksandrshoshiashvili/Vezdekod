//
//  EmojiFilter.swift
//  PodcastEdit
//
//  Created by Alexander Shoshiashvili on 18.09.20.
//  Copyright © 2020 Илья Егоров. All rights reserved.
//

import UIKit

struct EmojiFilter: Codable {

    enum Category: String, Codable, CaseIterable {
        case highEnergy
        case positive
        case negative
        case lowEnergy
    }

    let title: String
    let category: Category
    let emoji: String

    var id: String {
        return title
    }

}

extension EmojiFilter.Category {

    var value: String {
        switch self {
        case .highEnergy:
            return "😜"
        case .positive:
            return "😃"
        case .negative:
            return "🙁"
        case .lowEnergy:
            return "😴"
        }
    }

    var fullDescription: String {
        switch self {
        case .highEnergy:
            return "😜 Энергичный"
        case .positive:
            return "😃 Хорошее настроение"
        case .negative:
            return "🙁 Плохое настроение"
        case .lowEnergy:
            return "😴 Спокойный"
        }
    }
}
