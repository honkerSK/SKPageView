//
//  SKTitleView.swift
//  SKPageView
//
//  Created by sunke on 2020/7/9.
//  Copyright © 2020 KentSun. All rights reserved.
//

import UIKit

protocol SKTitleViewDelegate : class {
    func titleView(_ titleView : SKTitleView, currentIndex : Int)
}

class SKTitleView: UIView {
    // MARK: 定义属性
    weak var delegate : SKTitleViewDelegate?
    
    fileprivate var style : SKPageStyle
    fileprivate var titles : [String]
    fileprivate var currentIndex : Int = 0

    fileprivate lazy var titleLabels : [UILabel] = [UILabel]()
    fileprivate lazy var scrollView : UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.frame = self.bounds
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        return scrollView
    }()
    
    // MARK: 构造函数
    init(frame: CGRect, style : SKPageStyle, titles : [String]) {
        self.style = style
        self.titles = titles
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


// MARK:- 设置UI界面
extension SKTitleView {
    fileprivate func setupUI() {
        // 1.添加一个UIScrollView
        addSubview(scrollView)
        
        // 2.设置所有的标题
        setupTitleLabels()
        
        // 3.设置label的frame
        setupLabelsFrame()
    }
    
    private func setupLabelsFrame() {
        
        // 1.定义出变量&常量
        let labelH = style.titleHeight
        let labelY : CGFloat = 0
        var labelW : CGFloat = 0
        var labelX : CGFloat = 0
        
        // 2.设置titleLabel的frame
        let count = titleLabels.count
        for (i, titleLabel) in titleLabels.enumerated() {
            if style.isScrollEnable { // 可以滚动
                labelW = (titles[i] as NSString).boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: 0), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : titleLabel.font ?? UIFont.systemFont(ofSize: style.fontSize)], context: nil).width
                labelX = i == 0 ? style.titleMargin * 0.5 : (titleLabels[i-1].frame.maxX + style.titleMargin)
            } else { // 不可以滚动
                labelW = bounds.width / CGFloat(count)
                labelX = labelW * CGFloat(i)
            }
            
            titleLabel.frame = CGRect(x: labelX, y: labelY, width: labelW, height: labelH)
        }
        
        // 3.设置contentSize
        if style.isScrollEnable {
            scrollView.contentSize.width = titleLabels.last!.frame.maxX + style.titleMargin * 0.5
        }
    }
    
    private func setupTitleLabels() {
        // 元祖: (a,b)
        for (i, title) in titles.enumerated() {
            // 1.创建UILabel
            let label = UILabel()
            
            // 2.设置label的属性
            label.tag = i
            label.text = title
            label.textColor = i == 0 ? style.selectColor : style.normalColor
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: style.fontSize)
            
            // 3.将label添加到scrollView中
            scrollView.addSubview(label)
            
            // 4.将label添加到数组中
            titleLabels.append(label)
            
            // 5.监听label的点击
            let tapGes = UITapGestureRecognizer(target: self, action: #selector(titleLabelClick(_:)))
            label.addGestureRecognizer(tapGes)
            label.isUserInteractionEnabled = true
        }
    }
}


// MARK:- 监听label的点击
extension SKTitleView {
    @objc fileprivate func titleLabelClick(_ tapGes : UITapGestureRecognizer) {
        // 1.校验UILabel
        guard let targetLabel = tapGes.view as? UILabel else {
            return
        }
        guard targetLabel.tag != currentIndex else {
            return
        }
        
        // 2.取出原来的label
        let sourceLabel = titleLabels[currentIndex]
        
        // 3.改变Label的颜色
        sourceLabel.textColor = style.normalColor
        targetLabel.textColor = style.selectColor
        
        // 4.记录最新的index
        currentIndex = targetLabel.tag
        
        // 5.让点击的label居中显示
        adjustLabelPosition(targetLabel)
        
        // 6.通知代理
        delegate?.titleView(self, currentIndex: currentIndex)
    }
    
    private func adjustLabelPosition(_ targetLabel : UILabel) {
        // 1.计算一下offsetX
        var offsetX = targetLabel.center.x - bounds.width * 0.5
        
        // 2.临界值的判断
        if offsetX < 0 {
            offsetX = 0
        }
        if offsetX > scrollView.contentSize.width - scrollView.bounds.width {
            offsetX = scrollView.contentSize.width - scrollView.bounds.width
        }
        
        // 3.设置scrollView的contentOffset
        scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
    }
}
