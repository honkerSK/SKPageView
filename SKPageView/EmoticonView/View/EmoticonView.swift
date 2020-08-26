//
//  EmoticonView.swift
//  SKPageView
//
//  Created by sunke on 2020/8/26.
//  Copyright © 2020 KentSun. All rights reserved.
//

import UIKit

private let kPageCellID = "kPageCellID"

class EmoticonView: UIView {
    // MARK:- 构造函数
      override init(frame: CGRect) {
          super.init(frame: frame)
          setupUI()
      }
      
      required init?(coder aDecoder: NSCoder) {
          fatalError("init(coder:) has not been implemented")
      }

}

extension EmoticonView {
    fileprivate func setupUI() {
        // 1.创建SKPageCollectionView
        let style = SKPageStyle()
        style.normalColor = UIColor(r: 0, g: 0, b: 0)
        style.isBottomShow = true
        
        let pageFrame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
        let titles = ["普通", "粉丝专属"]
        let layout = SKPageCollectionViewLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.cols = 7
        layout.rows = 3
       
        let pageCollectionView = SKPageCollectionView(frame: pageFrame, titles: titles, style: style, layout: layout)
        pageCollectionView.dataSource = self
//        pageCollectionView.delegate = self
        pageCollectionView.registerNib("EmoticonViewCell", identifier: kPageCellID)
        // 2.将pageCollectionView添加到View中
        addSubview(pageCollectionView)
    }
}

extension EmoticonView : SKPageCollectionViewDataSource {
    func numberOfSectionInPageCollectionView() -> Int {
        return EmoticonManager.shareInstance.packages.count
    }
    
    func pageCollectionView(_ pageCollectionView: SKPageCollectionView, numberOfItemsInSection section: Int) -> Int {
        return EmoticonManager.shareInstance.packages[section].emoticons.count
    }
    
    func pageCollectionView(_ pageCollectionView: SKPageCollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = pageCollectionView.dequeueReusableCell(withReuseIdentifier: kPageCellID, for: indexPath) as! EmoticonViewCell
        
        cell.emoticon = EmoticonManager.shareInstance.packages[indexPath.section].emoticons[indexPath.item]
        cell.backgroundColor = UIColor.randomColor
        
        return cell
    }
}

