//
//  EmojiesService.swift
//  PodcastEdit
//
//  Created by Alexander Shoshiashvili on 18.09.20.
//  Copyright © 2020 Илья Егоров. All rights reserved.
//

import UIKit

final class EmojiesService {

    func getEmojiFilters() -> [EmojiFilter] {
        guard let path = Bundle.main.path(forResource: "emojies", ofType: "json") else {
            return []
        }
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            let jsonResult = try! JSONDecoder().decode([EmojiFilter].self, from: data)
            return jsonResult
        } catch {
            return []
        }
    }

}
