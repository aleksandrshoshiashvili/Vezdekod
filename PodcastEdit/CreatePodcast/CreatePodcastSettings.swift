//
//  CreatePodcastSettings.swift
//  PodcastEdit
//
//  Created by Alexander Shoshiashvili on 16.09.2020.
//  Copyright © 2020 Илья Егоров. All rights reserved.
//

import UIKit

struct CreatePodcastSettings {
    
    struct File {
        var name: String = ""
        var time: Int = 0
    }
    
    var icon: UIImage? = #imageLiteral(resourceName: "placeholder")
    var name: String = ""
    var descriptionText: String = ""
    var allowAbnormalСontent: Bool = false
    var excludeFromExport: Bool = false
    var trailerForPodcast: Bool = false
    var file: File? = nil
    
    var isSettingsValid: Bool {
        !descriptionText.isEmpty && !name.isEmpty
    }
}
