//
//  TopTitleViewController.swift
//  SKPageView
//
//  Created by sunke on 2020/8/25.
//  Copyright © 2020 KentSun. All rights reserved.
//

//顶部分类标题栏 示例代码
import UIKit

class TopTitleViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = .white
        
        //创建顶部分类标题栏
        setupTopPageView()
    }
    
    func setupTopPageView() {
        
        // 1.创建需要的样式
        let style = SKPageStyle()
        style.isScrollEnable = true
        style.isShowBottomLine = true
        //style.isShowCoverView = true
        
        
        // 2.获取所有的标题
        let titles = ["首页", "电器电器电器电器", "百货", "母婴", "洗护", "医药", "女装女装", "手机"]
        
        // 3.获取所有的内容控制器
        var childVcs = [UIViewController]()
        for _ in 0..<titles.count {
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor(red: CGFloat(arc4random_uniform(256))/255.0, green: CGFloat(arc4random_uniform(256))/255.0, blue: CGFloat(arc4random_uniform(256))/255.0, alpha: 1.0)
            childVcs.append(vc)
        }
        
        // 4.创建SKPageView
        let pageFrame = CGRect(x: 0, y: style.navigationBarHeight, width: view.bounds.width, height: view.bounds.height - style.navigationBarHeight)
        let pageView = SKPageView(frame: pageFrame, style: style, titles: titles, childVcs: childVcs, parentVc: self)
        pageView.backgroundColor = UIColor.blue
        view.addSubview(pageView)
        
    }
    
    
    
}
