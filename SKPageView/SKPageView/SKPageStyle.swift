//
//  SKPageStyle.swift
//  SKPageView
//
//  Created by sunke on 2020/7/9.
//  Copyright © 2020 KentSun. All rights reserved.
//

import UIKit

class SKPageStyle {
    //MARK:- 屏幕适配
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
    
    //MARK:- titleView设置
    /// 是否可以滚动
    var isScrollEnable : Bool = false
    
    ///titleView背景色
    let titleViewBgColor : UIColor = UIColor.lightGray
    
    // Label的一些属性
    var titleHeight : CGFloat = 44
    var normalColor : UIColor = UIColor.white
    var selectColor : UIColor = UIColor.red
    var fontSize : CGFloat = 15
    
    var titleMargin : CGFloat = 30
    
    /// 是否显示滚动条
    var isShowBottomLine : Bool = false
    /// 滚动条颜色
    var bottomLineColor : UIColor = UIColor.orange
    /// 滚动条线宽
    var bottomLineHeight : CGFloat = 4
    
    /// 是否需要缩放功能
    var isScaleEnable : Bool = false
    var maxScale : CGFloat = 1.2
    
    //MARK:- 标题背景coverView相关
    //是否需要显示的coverView
    var isShowCoverView : Bool = false
    var coverBgColor : UIColor = UIColor.black
    var coverAlpha : CGFloat = 0.4
    var coverMargin : CGFloat = 8
    var coverHeight : CGFloat = 25
    var coverRadius : CGFloat = 12
    
    
}












