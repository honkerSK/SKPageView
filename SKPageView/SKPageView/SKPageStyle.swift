//
//  SKPageStyle.swift
//  SKPageView
//
//  Created by sunke on 2020/7/9.
//  Copyright © 2020 KentSun. All rights reserved.
//

import UIKit

class SKPageStyle {
    /// 屏幕宽
    let screenWidth = UIScreen.main.bounds.width
    /// 屏幕高
    let screenHeight = UIScreen.main.bounds.height
    /// 屏幕bounds
    let screenBounds = UIScreen.main.bounds
    /// 状态栏高度
    let statusBarHeight = UIApplication.shared.statusBarFrame.size.height
    /// 导航栏高度
    let navigationBarHeight = UIApplication.shared.statusBarFrame.size.height + 44
    /// tabbar高度
    let tabbarItemHeight = (UIApplication.shared.statusBarFrame.size.height > 21) ? 83 : 49 as CGFloat
    /// 底部非安全区域高度
    let bottomSafeHeight = (UIApplication.shared.statusBarFrame.size.height > 21) ? 34 : 0 as CGFloat
    
    
    /// 是否可以滚动
    var isScrollEnable : Bool = false
    
    // Label的一些属性
    var titleHeight : CGFloat = 44
    var normalColor : UIColor = UIColor.white
    var selectColor : UIColor = UIColor.red
    var fontSize : CGFloat = 15
    
    var titleMargin : CGFloat = 30
    
    
    
}












