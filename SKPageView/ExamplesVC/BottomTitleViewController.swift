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
        let layout = SKPageCollectionViewLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.cols = 4
        layout.rows = 2
        
        
        // 4.创建pageCollectionView
        let pageCollectionViewFrame = CGRect(x: 0, y: style.navigationBarHeight, width: view.bounds.width, height: 300)
        let pageCollectionView = SKPageCollectionView(frame: pageCollectionViewFrame, titles: titles, style: style, layout: layout)
        pageCollectionView.dataSource = self
        pageCollectionView.delegate = self
        pageCollectionView.registerCell(UICollectionViewCell.self, identifier: kCollectionViewCellID)
        pageCollectionView.backgroundColor = UIColor.orange
        view.addSubview(pageCollectionView)
        
    }
    
}


extension BottomTitleViewController : SKPageCollectionViewDataSource {
    func numberOfSectionInPageCollectionView() -> Int {
        return 4
    }
    
    func pageCollectionView(_ pageCollectionView: SKPageCollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 12
        } else if section == 1 {
            return 30
        } else if section == 2 {
            return 7
        }
        return 12
    }
    
    func pageCollectionView(_ pageCollectionView: SKPageCollectionView,cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = pageCollectionView.dequeueReusableCell(withReuseIdentifier: kCollectionViewCellID, for: indexPath)
        cell.backgroundColor = UIColor.randomColor
        return cell
    }
    
}


extension BottomTitleViewController : SKPageCollectionViewDelegate {
    func pageCollectionView(_ pageCollectionView: SKPageCollectionView, didSelectedAtIndexPath indexPath: IndexPath) {
        print(indexPath)
    }
}


