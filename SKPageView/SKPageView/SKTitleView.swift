//
//  SKTitleView.swift
//  SKPageView
//
//  Created by sunke on 2020/7/9.
//  Copyright © 2020 KentSun. All rights reserved.
//

import UIKit

protocol SKTitleViewDelegate : class {
    ///监听每个label的点击
    func titleView(_ titleView : SKTitleView, currentIndex : Int)
}

class SKTitleView: UIView {
    // MARK: 定义属性
    weak var delegate : SKTitleViewDelegate?
    
    fileprivate var style : SKPageStyle
    fileprivate var titles : [String]
    fileprivate var currentIndex : Int = 0

    typealias ColorRGB = (red : CGFloat, green : CGFloat, blue : CGFloat)
    fileprivate lazy var selectRGB : ColorRGB = self.style.selectColor.getRGB()
    fileprivate lazy var normalRGB : ColorRGB = self.style.normalColor.getRGB()
    fileprivate lazy var deltaRGB : ColorRGB = {
        let deltaR = self.selectRGB.red - self.normalRGB.red
        let deltaG = self.selectRGB.green - self.normalRGB.green
        let deltaB = self.selectRGB.blue - self.normalRGB.blue
        return (deltaR, deltaG, deltaB)
    }()

    fileprivate lazy var titleLabels : [UILabel] = [UILabel]()
    fileprivate lazy var scrollView : UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.frame = self.bounds
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        return scrollView
    }()
    ///底部横线
    fileprivate lazy var bottomLine : UIView = {
        let bottomLine = UIView()
        bottomLine.backgroundColor = self.style.bottomLineColor
        bottomLine.frame.size.height = self.style.bottomLineHeight
        bottomLine.frame.origin.y = self.bounds.height - self.style.bottomLineHeight
        return bottomLine
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
        
        // 4.设置bottomLine
        setupBottomLine()
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

    
    private func setupBottomLine() {
        // 1.判断是否需要显示BottomLine
        guard style.isShowBottomLine else {
            return
        }
        
        // 2.将bottomLine添加到scrollView中
        scrollView.addSubview(bottomLine)
        
        // 3.设置bottomLine的frame中的属性
        bottomLine.frame.origin.x = titleLabels.first!.frame.origin.x
        bottomLine.frame.size.width = titleLabels.first!.frame.width
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
        
        // 7.调整bottomLine
        if style.isShowBottomLine {
            UIView.animate(withDuration: 0.25, animations: {
                self.bottomLine.frame.origin.x = targetLabel.frame.origin.x
                self.bottomLine.frame.size.width = targetLabel.frame.width
            })
        }
        
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


extension SKTitleView : SKContentViewDelegate {
    func contentView(_ contentView: SKContentView, inIndex: Int) {
        // 1.记录最新的currentIndex
        currentIndex = inIndex
        
        // 2.让targetLabel居中显示
        adjustLabelPosition(titleLabels[currentIndex])
    }
    
    func contentView(_ contentView: SKContentView, sourceIndex: Int, targetIndex: Int, progress: CGFloat) {
        // 1.获取sourceLabel&targetLabel
        let sourceLabel = titleLabels[sourceIndex]
        let targetLabel = titleLabels[targetIndex]
        
        // 2.颜色的渐变
        sourceLabel.textColor = UIColor(r: selectRGB.red - progress * deltaRGB.red, g: selectRGB.green - progress * deltaRGB.green, b: selectRGB.blue - progress * deltaRGB.blue)
        targetLabel.textColor = UIColor(r: normalRGB.red + progress * deltaRGB.red, g: normalRGB.green + progress * deltaRGB.green, b: normalRGB.blue + progress * deltaRGB.blue)
        
        // 3.bottomLine的调整
        if style.isShowBottomLine {
            let deltaX = targetLabel.frame.origin.x - sourceLabel.frame.origin.x
            let deltaW = targetLabel.frame.width - sourceLabel.frame.width
            bottomLine.frame.origin.x = sourceLabel.frame.origin.x + progress * deltaX
            bottomLine.frame.size.width = sourceLabel.frame.width + progress * deltaW
        }
    }
}

