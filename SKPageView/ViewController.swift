//
//  ViewController.swift
//  SKPageView
//
//  Created by sunke on 2020/7/9.
//  Copyright © 2020 KentSun. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: 重写的函数
    override func viewDidLoad() {
        super.viewDidLoad()
        
        automaticallyAdjustsScrollViewInsets = false
        
        // 1.创建需要的样式
        let style = SKPageStyle()
        style.isScrollEnable = true
        
        // 2.获取所有的标题
        // let titles = ["推荐", "游戏", "热门", "趣玩", "娱乐"]
        let titles = ["推荐", "游戏游戏游戏", "热门游戏", "趣玩游", "娱乐", "热门游戏", "趣玩游", "娱乐"]
        
        // 3.获取所有的内容控制器
        // 两种区间
        // 0..<5 : 0~4
        // 0...5 : 0~5
        var childVcs = [UIViewController]()
        for _ in 0..<titles.count {
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor(red: CGFloat(arc4random_uniform(256))/255.0, green: CGFloat(arc4random_uniform(256))/255.0, blue: CGFloat(arc4random_uniform(256))/255.0, alpha: 1.0)
            childVcs.append(vc)
        }
        
        // 4.创建SKPageView
        let pageFrame = CGRect(x: 0, y: style.navigationBarHeight, width: view.bounds.width, height: view.bounds.height - style.navigationBarHeight)
        let pageView = SKPageView(frame: pageFrame, style: style, titles: titles, childVcs: childVcs)
        pageView.backgroundColor = UIColor.blue
        view.addSubview(pageView)
    }
    
}

