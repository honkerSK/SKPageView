//
//  EmoticonPackage.swift
//  SKPageView
//
//  Created by sunke on 2020/8/26.
//  Copyright © 2020 KentSun. All rights reserved.
//

import UIKit

class EmoticonPackage {
    
    lazy var emoticons : [Emoticon] = [Emoticon]()
    
    init(plistName : String) {
        guard let path = Bundle.main.path(forResource: plistName, ofType: nil) else {
            return
        }
        
        guard let emotionArray = NSArray(contentsOfFile: path) as? [String] else {
            return
        }
        
        for str in emotionArray {
            emoticons.append(Emoticon(emoticonName: str))
        }
    }
}

