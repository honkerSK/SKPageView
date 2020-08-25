//
//  SKPageView.swift
//  SKPageView
//
//  Created by sunke on 2020/7/9.
//  Copyright © 2020 KentSun. All rights reserved.
//

import UIKit

///数据源方法
protocol SKPageViewDataSource : NSObjectProtocol {
    ///有多少组
    func numberOfSectionsInPageView(_ pageView : SKPageView) -> Int
    ///每组多少个
    func pageView(_ pageView : SKPageView, numberOfItemsInSection section: Int) -> Int
    ///设置每个cell
    func pageView(_ pageView : SKPageView, cellForItemAtIndexPath indexPath : IndexPath) -> UICollectionViewCell
}

@objc protocol SKPageViewDelegate : NSObjectProtocol {
    ///点击cell响应方法
    @objc optional func pageView(_ pageView : SKPageView, didSelectedAtIndexPath indexPath : IndexPath)
}


class SKPageView: UIView {
    
    // 在swift中, 如果子类有自定义构造函数, 或者重新父类的构造函数, 那么必须实现父类中使用required修饰的构造函数
    weak var dataSource : SKPageViewDataSource?
    weak var delegate : SKPageViewDelegate?
    
    // MARK: 定义属性
    var style : SKPageStyle
    var titles : [String]
    var childVcs : [UIViewController]!
    var parentVc : UIViewController!
    fileprivate var layout : SKPageViewLayout!
    
    fileprivate var collectionView : UICollectionView!
    fileprivate var pageControl : UIPageControl!
    //记录最新的currentSection
    fileprivate lazy var currentSection : Int = 0
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
        // self.不能省略: 在函数中, 如果和成员属性产生歧义
        self.style = style
        self.titles = titles
        self.childVcs = childVcs
        self.parentVc = parentVc
        super.init(frame: frame)
        
        setupContentUI()
    }
    
    ///初始化底部标题栏
    init(frame: CGRect, style : SKPageStyle, titles : [String], layout : SKPageViewLayout) {
        self.style = style
        self.titles = titles
        self.layout = layout
        super.init(frame: frame)
        setupCollectionUI()
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
    
    // MARK: 初始化collectionView的UI
    fileprivate func setupCollectionUI() {
        // 1.添加titleView
        self.addSubview(titleView)
        
        // 2.添加collectionView
        let collectionFrame = CGRect(x: 0, y: style.titleHeight, width: bounds.width, height: bounds.height - style.titleHeight - style.pageControlHeight)
        
        collectionView = UICollectionView(frame: collectionFrame, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.scrollsToTop = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        addSubview(collectionView)
        
        // 3.添加UIPageControl
        let pageControlFrame = CGRect(x: 0, y: collectionView.frame.maxY, width: bounds.width, height: style.pageControlHeight)
        pageControl = UIPageControl(frame: pageControlFrame)
        pageControl.numberOfPages = 4
        addSubview(pageControl)
        pageControl.isEnabled = false
        
        // 4.监听titleView的点击
        titleView.delegate = self
    }
    
}


// MARK:- UICollectionView的数据源
extension SKPageView : UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource?.numberOfSectionsInPageView(self) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let itemCount = dataSource?.pageView(self, numberOfItemsInSection: section) ?? 0
        if section == 0 {
            pageControl.numberOfPages = (itemCount - 1) / (layout.cols * layout.rows) + 1
        }
        return itemCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return dataSource!.pageView(self, cellForItemAtIndexPath: indexPath)
    }
}

extension SKPageView : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.pageView?(self, didSelectedAtIndexPath: indexPath)
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
        let point = CGPoint(x: layout.sectionInset.left + collectionView.contentOffset.x, y: layout.sectionInset.top)
        guard let indexPath = collectionView.indexPathForItem(at: point) else {
            return
        }
        
        // 2.如果发现组(section)发生了改变, 那么重新设置pageControl的numberOfPages
        if indexPath.section != currentSection {
            // 2.1.改变pageControl的numberOfPages
            let itemCount = dataSource?.pageView(self, numberOfItemsInSection: indexPath.section) ?? 0
            pageControl.numberOfPages = (itemCount - 1) / (layout.rows * layout.cols) + 1
            
            // 2.2.记录最新的currentSection
            currentSection = indexPath.section
            
            // 2.3.让titleView选中最新的title
            titleView.setCurrentIndex(currentIndex: currentSection)
        }
        
        // 3.显示pageControl正确的currentPage
        let pageIndex = indexPath.item / 8
        pageControl.currentPage = pageIndex
    }
}


// MARK:- 实现HYTitleView的代理方法
extension SKPageView : SKTitleViewDelegate {
    func titleView(_ titleView: SKTitleView, currentIndex: Int) {
        // 1.滚动到正确的位置
        let indexPath = IndexPath(item: 0, section: currentIndex)
        collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
        
        // 2.微调collectionView -- contentOffset
        collectionView.contentOffset.x -= layout.sectionInset.left
        
        // 3.改变pageControl的numberOfPages
        let itemCount = dataSource?.pageView(self, numberOfItemsInSection: currentIndex) ?? 0
        pageControl.numberOfPages = (itemCount - 1) / (layout.rows * layout.cols) + 1
        pageControl.currentPage = 0
        
        // 4.记录最新的currentSection
        currentSection = currentIndex
    }
}


// MARK:- 对外提供的函数
extension SKPageView {
    ///注册cell
    func registerCell(_ cellClass : AnyClass?, identifier : String) {
        collectionView.register(cellClass, forCellWithReuseIdentifier: identifier)
    }
    func registerNib(_ nib : UINib?, identifier : String) {
        collectionView.register(nib, forCellWithReuseIdentifier: identifier)
    }
    
    func dequeueReusableCell(withReuseIdentifier : String, for indexPath : IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: withReuseIdentifier, for: indexPath)
    }
}
