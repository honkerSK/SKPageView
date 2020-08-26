//
//  SKPageCollectionViewLayout.swift
//  SKPageView
//
//  Created by sunke on 2020/8/26.
//  Copyright © 2020 KentSun. All rights reserved.
//

import UIKit

class SKPageCollectionViewLayout: UICollectionViewLayout {
    fileprivate lazy var cellAttrs : [UICollectionViewLayoutAttributes] = [UICollectionViewLayoutAttributes]()
    ///组内边距
    var sectionInset : UIEdgeInsets = UIEdgeInsets.zero
    ///列间距
    var minimumInteritemSpacing : CGFloat = 0
    ///行间距
    var minimumLineSpacing : CGFloat = 0
    ///指定每组多少行 多少列
    var cols = 4
    var rows = 2
    ///计算该组一共占据多少页
    fileprivate lazy var pageCount = 0
    
    var isTitleInTop : Bool = true

}


// MARK:- 准备所有的布局
extension SKPageCollectionViewLayout {
    override func prepare() {
        super.prepare()
        
        // 1.对collectionView进行校验
        guard let collectionView = collectionView else {
            return
        }
        
        // 2.获取多少组
        let sectionCount = collectionView.numberOfSections
        
        // 3.获取每组中有多少个数据
        let itemW : CGFloat = (collectionView.bounds.width - sectionInset.left - sectionInset.right - CGFloat(cols - 1) * minimumInteritemSpacing) / CGFloat(cols)
        let itemH : CGFloat = (collectionView.bounds.height - sectionInset.top - sectionInset.bottom - CGFloat(rows - 1) * minimumLineSpacing) / CGFloat(rows)
        // 计算累加的组有多少页
        for sectionIndex in 0..<sectionCount {
            let itemCount = collectionView.numberOfItems(inSection: sectionIndex)
            
            // 4.为每一个cell创建对应的UICollectionViewLayoutAttributes
            for itemIndex in 0..<itemCount {
                // 4.1.创建Attributes
                let indexPath = IndexPath(item: itemIndex, section: sectionIndex)
                let attr = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                
                // 4.2.求出itemIndex在该组中的第几页中的第几个
                let pageIndex = itemIndex / (rows * cols)
                let pageItemIndex = itemIndex % (rows * cols)
                
                // 4.3.求itemIndex在该也中第几行/第几列
                let rowIndex = pageItemIndex / cols
                let colIndex = pageItemIndex % cols
                
                // 4.2.设置Attributes的frame
                let itemY : CGFloat = sectionInset.top + (itemH + minimumLineSpacing) * CGFloat(rowIndex)
                let itemX : CGFloat = CGFloat(pageCount + pageIndex) * collectionView.bounds.width + sectionInset.left + (itemW + minimumInteritemSpacing) * CGFloat(colIndex)
                attr.frame = CGRect(x: itemX, y: itemY, width: itemW, height: itemH)
                
                // 4.3.将Attributes添加到数组中
                cellAttrs.append(attr)
            }
            
            // 5.计算该组一共占据多少页
            pageCount += (itemCount - 1) / (cols * rows) + 1
        }
    }
}


// MARK:- 返回布局
extension SKPageCollectionViewLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cellAttrs
    }
}

// MARK:- 设置可滚动的区域
extension SKPageCollectionViewLayout {
    override var collectionViewContentSize: CGSize {
        return CGSize(width: CGFloat(pageCount) * collectionView!.bounds.width, height: 0)
    }
}

