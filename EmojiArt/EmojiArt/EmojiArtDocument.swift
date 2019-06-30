//
//  Document.swift
//  EmojiArt
//
//  Created by mingkai on 2019/6/28.
//  Copyright © 2019年 mingkai. All rights reserved.
//

import UIKit

class EmojiArtDocument: UIDocument {
    var emojiArt: EmojiArt?
    var thumbnail: UIImage?
    
    override func contents(forType typeName: String) throws -> Any {
        return emojiArt?.json ?? Data()
    }
    
    override func load(fromContents contents: Any, ofType typeName: String?) throws {
        // Load your document from contents
        if let json = contents as? Data {
            emojiArt = EmojiArt(json: json)
        }
    }
    
    override func fileAttributesToWrite(to url: URL, for saveOperation: UIDocumentSaveOperation) throws -> [AnyHashable : Any] {
        var attributes = try super.fileAttributesToWrite(to: url, for: saveOperation)
        if let thumbnail = self.thumbnail{
            attributes[URLResourceKey.thumbnailDictionaryKey] = [URLThumbnailDictionaryItem.NSThumbnail1024x1024SizeKey:thumbnail]
        }
        return attributes
    }
}

