//
//  SKContentView.swift
//  SKPageView
//
//  Created by sunke on 2020/7/9.
//  Copyright © 2020 KentSun. All rights reserved.
//

import UIKit

class SKContentView: UIView {

    fileprivate var childVcs : [UIViewController]

    init(frame: CGRect, childVcs : [UIViewController]) {
        self.childVcs = childVcs
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
