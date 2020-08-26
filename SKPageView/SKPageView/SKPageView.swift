//
//  SKPageView.swift
//  SKPageView
//
//  Created by sunke on 2020/7/9.
//  Copyright © 2020 KentSun. All rights reserved.
//

import UIKit


class SKPageView: UIView {
       
    // MARK: 定义属性
    var style : SKPageStyle
    var titles : [String]
    var childVcs : [UIViewController]!
    var parentVc : UIViewController!
    
    //懒加载标题view
    fileprivate lazy var titleView : SKTitleView = {
        let titleFrame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.style.titleHeight)
        let titleView = SKTitleView(frame: titleFrame, style: self.style, titles: self.titles)
        titleView.backgroundColor = UIColor.blue
        return titleView
    }()
    
    // MARK: 构造函数
    ///初始化顶部标题栏
    init(frame: CGRect, style : SKPageStyle, titles : [String], childVcs : [UIViewController], parentVc : UIViewController) {
        // 在super.init()之前, 需要保证所有的属性有被初始化
        self.style = style
        self.titles = titles
        self.childVcs = childVcs
        self.parentVc = parentVc
        super.init(frame: frame)
        
        setupContentUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK:- 初始化UI界面
extension SKPageView {
    fileprivate func setupContentUI() {
        self.addSubview(titleView)
        
        // 1.创建SKTitleView
        let titleFrame = CGRect(x: 0, y: 0, width: bounds.width, height: style.titleHeight)
        let titleView = SKTitleView(frame: titleFrame, style: style, titles: titles)
        titleView.backgroundColor = style.titleViewBgColor
        addSubview(titleView)
        
        // 2.创建SKContentView
        let contentFrame = CGRect(x: 0, y: style.titleHeight, width: bounds.width, height: bounds.height - style.titleHeight)
        let contentView = SKContentView(frame: contentFrame, childVcs: childVcs, parentVc: parentVc)
        contentView.backgroundColor = UIColor.purple
        addSubview(contentView)
        
        // 3.让SKTitleView&SKContentView进行交互
        titleView.delegate = contentView
        contentView.delegate = titleView
    }
    
   
    
}


