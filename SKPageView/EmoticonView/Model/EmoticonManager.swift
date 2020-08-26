//
//  EmoticonManager.swift
//  SKPageView
//
//  Created by sunke on 2020/8/26.
//  Copyright © 2020 KentSun. All rights reserved.
//

import UIKit

class EmoticonManager {
    static let shareInstance : EmoticonManager = EmoticonManager()
    lazy var packages : [EmoticonPackage] = [EmoticonPackage]()
    
    private init() {
        packages.append(EmoticonPackage(plistName: "QHNormalEmotionSort.plist"))
        packages.append(EmoticonPackage(plistName: "QHSohuGifSort.plist"))
    }
}
