//
//  Constants.swift
//  MemeMe
//
//  Created by Stefan Jaindl on 31.03.18.
//  Copyright © 2018 Stefan Jaindl. All rights reserved.
//

import Foundation
import UIKit

struct MemeText {
    static let topText = "TOP"
    static let bottomText = "BOTTOM"
    
    static let topTag = 1
    static let bottomTag = 2
    
    static let textFieldDefaultAttributes: [String: Any] = [
        NSAttributedStringKey.font.rawValue : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedStringKey.foregroundColor.rawValue : UIColor.white,
        NSAttributedStringKey.strokeWidth.rawValue : "-1",
        NSAttributedStringKey.strokeColor.rawValue : UIColor.black
    ]
}

struct MemeIds {
    static let MEME_TABLE_CELL_ID: String = "SentMemeTableCell"
    static let MEME_COLLECTION_VIEW_CELL_ID: String = "SentMemeCollectionViewCell"
    static let MEME_DETAIL_SEGUE_ID: String = "showDetail"
}
