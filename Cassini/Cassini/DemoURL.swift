//
//  DemoURL.swift
//  Cassini
//
//  Created by mingkai on 2019/6/22.
//  Copyright © 2019年 mingkai. All rights reserved.
//

import Foundation

struct DemoURLs {
    static let nasa0 = URL(string: "https://climate.nasa.gov/system/content_pages/main_images/11_Earth_Fleet_Operating_FEB_2017.jpeg")
    static let NASA: Dictionary<String,URL>={
        let NASAURLStrings = [
            "nasa1":"https://www.nasa.gov/sites/default/files/styles/full_width/public/thumbnails/image/s95015632.jpg?itok=2r31W_6H",
            "nasa2":"https://www.nasa.gov/sites/default/files/styles/full_width/public/thumbnails/image/orion-aa2-rollout.jpg?itok=z-epdifw",
            "nasa3":"https://s23527.pcdn.co/wp-content/uploads/2017/04/nasa-gallery.jpg.optimal.jpg"
        ]
        
        var urls = Dictionary<String, URL>()
        for (k,v) in NASAURLStrings{
            urls[k] = URL(string: v)
        }
        return urls
    }()
}
