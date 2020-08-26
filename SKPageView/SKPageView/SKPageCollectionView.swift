//
//  SKPageCollectionView.swift
//  SKPageView
//
//  Created by sunke on 2020/8/26.
//  Copyright © 2020 KentSun. All rights reserved.
//

import UIKit

///数据源
protocol SKPageCollectionViewDataSource : NSObjectProtocol {
    ///有多少组
    func numberOfSectionInPageCollectionView() -> Int
    ///每组多少个
    func pageCollectionView(_ pageCollectionView : SKPageCollectionView, numberOfItemsInSection section : Int) -> Int
    ///设置每个cell
    func pageCollectionView(_ pageCollectionView : SKPageCollectionView, cellForItemAt indexPath : IndexPath) -> UICollectionViewCell
}

@objc protocol SKPageCollectionViewDelegate : NSObjectProtocol {
    ///点击cell响应方法
    @objc optional func pageCollectionView(_ pageCollectionView : SKPageCollectionView, didSelectedAtIndexPath indexPath : IndexPath)
    
}

class SKPageCollectionView: UIView {
    
    weak var dataSource : SKPageCollectionViewDataSource?
    weak var delegate : SKPageCollectionViewDelegate?
    
    fileprivate var titles : [String]
    fileprivate var style : SKPageStyle
    fileprivate var layout : SKPageCollectionViewLayout
    
    //fileprivate var titleView : SKTitleView!
    //懒加载标题view
    fileprivate lazy var titleView : SKTitleView = {
        //let titleY = layout.isTitleInTop ? 0 : (frame.height - style.titleHeight)
        let titleFrame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.style.titleHeight)
        let titleView = SKTitleView(frame: titleFrame, style: self.style, titles: self.titles)
        titleView.backgroundColor = style.titleViewBgColor
        return titleView
    }()
    
    fileprivate var collectionView : UICollectionView!
    fileprivate var pageControl : UIPageControl!
    
    //fileprivate lazy var currentIndexPath : IndexPath = IndexPath(item: 0, section: 0)
    //记录最新的currentSection
    fileprivate lazy var currentSection : Int = 0
    
    init(frame: CGRect, titles : [String], style : SKPageStyle, layout : SKPageCollectionViewLayout) {
        self.titles = titles
        self.style = style
        self.layout = layout
        super.init(frame: frame)
        setupUI()
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

extension SKPageCollectionView{
    
    fileprivate func setupUI() {
        // 1.titleView
        addSubview(titleView)
       
        // 2.UICollectionView
        let collectionY = layout.isTitleInTop ? style.titleHeight : 0
        //判断是否底部显示
        let collectionSageHeight = (style.isBottomShow == true) ? style.bottomSafeHeight : 0
        let collectionH = frame.height - style.titleHeight - style.pageControlHeight - collectionSageHeight
        let collectionFrame = CGRect(x: 0, y: collectionY, width: frame.width, height: collectionH)
        collectionView = UICollectionView(frame: collectionFrame, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isPagingEnabled = true
        collectionView.scrollsToTop = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.bounces = false
        addSubview(collectionView)
        
        // 3.UIPageControl
        let pageControlFrame = CGRect(x: 0, y: collectionView.frame.maxY, width: frame.width, height: style.pageControlHeight)
        pageControl = UIPageControl(frame: pageControlFrame)
        pageControl.numberOfPages = 4
        pageControl.isEnabled = false
        pageControl.pageIndicatorTintColor = UIColor.white
        pageControl.currentPageIndicatorTintColor = UIColor.orange
        pageControl.backgroundColor = UIColor.blue
        addSubview(pageControl)
        
        // 4.监听titleView的点击
        titleView.delegate = self
    }
        
      
}


// MARK:- UICollectionView的数据源
extension SKPageCollectionView : UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource?.numberOfSectionInPageCollectionView() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let itemCount = dataSource?.pageCollectionView(self, numberOfItemsInSection: section) ?? 0
        if section == 0 {
            pageControl.numberOfPages = (itemCount - 1) / (layout.cols * layout.rows) + 1
        }
        return itemCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return dataSource!.pageCollectionView(self, cellForItemAt: indexPath)
    }
}

extension SKPageCollectionView : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.pageCollectionView?(self, didSelectedAtIndexPath: indexPath)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        collectionViewDidEndScroll()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            collectionViewDidEndScroll()
        }
    }
    
    func collectionViewDidEndScroll() {
        // 1.获取当前显示页中的某一个cell的indexPath
        let point = CGPoint(x: layout.sectionInset.left + collectionView.contentOffset.x + 1, y: layout.sectionInset.top + 1)
        guard let indexPath = collectionView.indexPathForItem(at: point) else {
            return
        }
        
        // 2.如果发现组(section)发生了改变, 那么重新设置pageControl的numberOfPages
        if indexPath.section != currentSection {
            // 2.1.改变pageControl的numberOfPages
            let itemCount = dataSource?.pageCollectionView(self, numberOfItemsInSection: indexPath.section) ?? 0
            pageControl.numberOfPages = (itemCount - 1) / (layout.rows * layout.cols) + 1
            
            // 2.2.记录最新的currentSection
            currentSection = indexPath.section
            
            // 2.3.让titleView选中最新的title
            titleView.setCurrentIndex(currentIndex: currentSection)
        }
        
        // 3.显示pageControl正确的currentPage
        let pageIndex = indexPath.item / (layout.rows * layout.cols)
        pageControl.currentPage = pageIndex
    }
}


// MARK:- 实现SKTitleView的代理方法
extension SKPageCollectionView : SKTitleViewDelegate {
    func titleView(_ titleView: SKTitleView, currentIndex: Int) {
        // 1.滚动到正确的位置
        let indexPath = IndexPath(item: 0, section: currentIndex)
        collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
        
        // 2.微调collectionView -- contentOffset
        collectionView.contentOffset.x -= layout.sectionInset.left
        
        // 3.改变pageControl的numberOfPages
        let itemCount = dataSource?.pageCollectionView(self, numberOfItemsInSection: currentIndex) ?? 0
        pageControl.numberOfPages = (itemCount - 1) / (layout.rows * layout.cols) + 1
        pageControl.currentPage = 0
        
        // 4.记录最新的currentSection
        currentSection = currentIndex
    }
}


// MARK:- 对外提供的函数
extension SKPageCollectionView {
    ///注册cell
    func registerCell(_ cellClass : AnyClass?, identifier : String) {
        collectionView.register(cellClass, forCellWithReuseIdentifier: identifier)
    }
    func registerNib(_ nibName : String, identifier : String) {
        let nib = UINib(nibName: nibName, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: identifier)
    }
    
    func dequeueReusableCell(withReuseIdentifier : String, for indexPath : IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: withReuseIdentifier, for: indexPath)
    }
    
}
