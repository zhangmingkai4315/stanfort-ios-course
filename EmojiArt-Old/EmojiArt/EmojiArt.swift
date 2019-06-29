//
//  EmojiArt.swift
//  EmojiArt
//
//  Created by mingkai on 2019/6/28.
//  Copyright © 2019年 mingkai. All rights reserved.
//

import Foundation

struct EmojiArt: Codable {
    var url: URL
    var emojis = [EmojiInfo]()
    
    struct EmojiInfo: Codable{
        var x: Int
        var y: Int
        let text: String
        let size: Int
    }
    
    // 可失败的初始化
    init?(json: Data){
        if let newValue = try? JSONDecoder().decode(EmojiArt.self, from: json){
            self = newValue
        }else{
            return nil
        }
    }
    
    init(url: URL, emojis: [EmojiInfo]) {
        self.url = url
        self.emojis = emojis
    }
    
    var json: Data?{
        return try? JSONEncoder().encode(self)
    }
    
    
}
