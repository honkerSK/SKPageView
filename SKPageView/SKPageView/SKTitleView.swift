//
//  SKTitleView.swift
//  SKPageView
//
//  Created by sunke on 2020/7/9.
//  Copyright © 2020 KentSun. All rights reserved.
//

import UIKit

class SKTitleView: UIView {
    
    fileprivate var style : SKPageStyle
    fileprivate var titles : [String]
    
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
            // 事件监听依然是发送消息
            // swift: #selector
            let tapGes = UITapGestureRecognizer(target: self, action: #selector(titleLabelClick(_:)))
            label.addGestureRecognizer(tapGes)
            label.isUserInteractionEnabled = true
        }
    }
}


// MARK:- 监听label的点击
extension SKTitleView {
    // tapGes : 外部参数
    // @objc 如果在函数前加载@objc, 那么会保留OC的特性
    // OC在调用方法时, 本质是发送消息
    // 将方法包装成 @SEL --> 根据@SEL去类中的方法映射表 --> IMP指针
    // 目的: 灵活 --> 不安全
    @objc fileprivate func titleLabelClick(_ tapGes : UITapGestureRecognizer) {
        // 1.校验UILabel
        guard let targetLabel = tapGes.view as? UILabel else {
            return
        }
        
        // 2.获取下标值
        print(targetLabel.tag)
    }
}
