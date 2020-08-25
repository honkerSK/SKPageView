//
//  BottomTitleViewController.swift
//  SKPageView
//
//  Created by sunke on 2020/8/25.
//  Copyright © 2020 KentSun. All rights reserved.
//

//底部分类标题 示例代码
import UIKit

private let kCollectionViewCellID = "kCollectionViewCellID"


class BottomTitleViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = .white

        setupBottomPageView()
    }
    
    func setupBottomPageView() {
        // 1.创建需要的样式
        let style = SKPageStyle()
        
        // 2.获取所有的标题
        let titles = ["百货", "母婴", "洗护", "医药"]
        
        // 3.创建布局
        let layout = SKPageViewLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.lineSpacing = 10
        layout.itemSpacing = 10
        layout.cols = 7
        layout.rows = 3
        
        
        // 4.创建HYPageView
        let pageFrame = CGRect(x: 0, y: style.navigationBarHeight, width: view.bounds.width, height: 300)
        let pageView = SKPageView(frame: pageFrame, style: style, titles: titles, layout : layout)
        pageView.dataSource = self
        pageView.delegate = self
        pageView.registerCell(UICollectionViewCell.self, identifier: kCollectionViewCellID)
        pageView.backgroundColor = UIColor.orange
        view.addSubview(pageView)
        
    }

}


extension BottomTitleViewController : SKPageViewDataSource {
    func numberOfSectionsInPageView(_ pageView: SKPageView) -> Int {
        return 4
    }
    
    func pageView(_ pageView: SKPageView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 70
        } else if section == 1 {
            return 15
        } else if section == 2 {
            return 45
        }
        return 40
    }
    
    func pageView(_ pageView: SKPageView, cellForItemAtIndexPath indexPath: IndexPath) -> UICollectionViewCell {
        let cell = pageView.dequeueReusableCell(withReuseIdentifier: kCollectionViewCellID, for: indexPath)
        
        cell.backgroundColor = UIColor.randomColor
        return cell
    }
}


extension BottomTitleViewController : SKPageViewDelegate {
    func pageView(_ pageView: SKPageView, didSelectedAtIndexPath indexPath: IndexPath) {
        print(indexPath)
    }
    
}


