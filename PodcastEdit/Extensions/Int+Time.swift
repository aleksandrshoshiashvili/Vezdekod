//
//  Int+Time.swift
//  PodcastEdit
//
//  Created by Илья Егоров on 17.09.2020.
//  Copyright © 2020 Илья Егоров. All rights reserved.
//

import UIKit

extension Int {

    var timeString: String {
        if self < 0 { return "00:00" }
        
        var resultString = ""
        if self >= 3600 {
            resultString += String(self / 3600) + ":"
        }
        resultString += String(format: "%02d:%02d", (self % 3600) / 60, self % 60)
        return resultString
    }

}
