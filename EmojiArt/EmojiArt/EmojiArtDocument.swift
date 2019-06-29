//
//  Document.swift
//  EmojiArt
//
//  Created by mingkai on 2019/6/28.
//  Copyright © 2019年 mingkai. All rights reserved.
//

import UIKit

class EmojiArtDocument: UIDocument {
    
    override func contents(forType typeName: String) throws -> Any {
        // Encode your document with an instance of NSData or NSFileWrapper
        return Data()
    }
    
    override func load(fromContents contents: Any, ofType typeName: String?) throws {
        // Load your document from contents
    }
}

