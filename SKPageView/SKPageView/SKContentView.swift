//
//  SKContentView.swift
//  SKPageView
//
//  Created by sunke on 2020/7/9.
//  Copyright © 2020 KentSun. All rights reserved.
//

import UIKit

private let kContentCellID = "kContentCellID"

class SKContentView: UIView {
    // MARK: 定义属性
    fileprivate var childVcs : [UIViewController]
    fileprivate var parentVc : UIViewController
    fileprivate lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = self.bounds.size
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.scrollsToTop = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.bounces = false
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: kContentCellID)
        return collectionView
    }()
    
    // MARK: 构造函数
    init(frame: CGRect, childVcs : [UIViewController], parentVc:UIViewController) {
        self.childVcs = childVcs
        self.parentVc = parentVc
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}


extension SKContentView {
    fileprivate func setupUI() {
        // 1.添加collectionView
        addSubview(collectionView)
        
        // 2.将所有的子控制器添加到父控制器中
        for childVc in childVcs {
            parentVc.addChild(childVc)
        }
    }
}

extension SKContentView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVcs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 1.获取cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kContentCellID, for: indexPath)
        
        // 2.给cell设置内容
        for subview in cell.contentView.subviews {
            subview.removeFromSuperview()
        }
        let childVc = childVcs[indexPath.item]
        childVc.view.frame = cell.contentView.bounds
        cell.contentView.addSubview(childVc.view)
        
        return cell
    }
    
    
}


extension SKContentView : UICollectionViewDelegate {
    
}

extension SKContentView : SKTitleViewDelegate {
    func titleView(_ titleView: SKTitleView, currentIndex: Int) {
        // 1.根据currentIndex获取indexPath
        let indexPath = IndexPath(item: currentIndex, section: 0)
        
        // 2.滚动到正确的位置
        collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
    }
}
