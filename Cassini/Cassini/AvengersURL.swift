//
//  DemoURL.swift
//  Cassini
//
//  Created by 明凯张 on 2019/5/25.
//  Copyright © 2019 明凯张. All rights reserved.
//

import Foundation


struct AvengersURL {
    static let familyImage = URL(string: "https://hdqwalls.com/download/1/avengers-endgame-2019-movie-y2-1280x800.jpg")
    static var Avengers: Dictionary<String, URL> = {
        let AvengersStrings = ["captain":"https://hdqwalls.com/download/1/2019-captain-america-mjolnir-avengers-endgame-4k-gv-1336x768.jpg",     "ironman":"https://hdqwalls.com/download/1/avengers-age-of-ultron-iron-man-artwork-ii-1280x800.jpg",
        "thor":"https://images.hdqwalls.com/wallpapers/bthumb/avengers-age-of-ultron-thor-artwork-b6.jpg",
        ]
        var urls = Dictionary<String,URL>()
        for (key,value) in AvengersStrings{
            urls[key] = URL(string: value)
        }
        return urls
    }()
}
