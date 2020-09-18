//
//  TitleSubtitleAndValue.swift
//  PodcastEdit
//
//  Created by Alexander Shoshiashvili on 16.09.2020.
//  Copyright © 2020 Илья Егоров. All rights reserved.
//

import SwiftyListKit

struct TitleSubtitleAndValue<Value>: ListItemDataModel {
    var tag: Any?
    let title: String
    let subtitle: String
    let value: Value
}
