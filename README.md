# SKPageView


### swift5.1版 分类标题栏, 带下划线或者背景的标题栏


#### 带下划线分类标题栏
<img src="https://github.com/honkerSK/SKPageView/tree/master/img/bottomLine.png" width="500" alt="SKPageView"></img>



#### 带背景分类标题栏
<img src="https://github.com/honkerSK/SKPageView/tree/master/img/coverView.png" width="500" alt="SKPageView"></img>


#### 使用简介,可参考源码中 ViewController.swift

1.设置需要的样式, SKPageStyle属性根据需求设置,都有默认值

```
let style = SKPageStyle()
//是否可以滚动,不滚动根据文本个数平分, 默认滚动
style.isScrollEnable = true

//titleView背景色
style.titleViewBgColor = UIColor.lightGray

// Label的一些属性
style.titleHeight = 44  //标题栏高度
style.normalColor = UIColor.white //未选中文本颜色
style.selectColor = UIColor.red //选中文本颜色
style.fontSize  = 15 //文本字号
style.titleMargin = 30 //文件间距

//是否显示滚动条,默认显示
style.isShowBottomLine = true
// 滚动条颜色
style.bottomLineColor = UIColor.orange
// 滚动条线宽
style.bottomLineHeight = 4

// 是否需要缩放功能, 默认不缩放 false
style.isScaleEnable = true
// 缩放比例
var maxScale = 1.2

//标题背景coverView相关
//是否需要显示的coverView, 默认不显示
style.isShowCoverView  = false
style.coverBgColor  = UIColor.black //标题背景颜色
style.coverAlpha = 0.4 //标题背景alpha值
style.coverMargin  = 8 //标题背景间距
style.coverHeight  = 25 //标题背景高度
style.coverRadius = 12 //标题背景圆角
```

2.设置所有的标题
```
let titles = ["首页", "电器电器电器电器", "百货", "母婴", "洗护", "医药", "女装女装", "手机"]
```

3.设置所有的内容控制器
```
var childVcs = [UIViewController]()
for _ in 0..<titles.count {
    let vc = UIViewController()
    vc.view.backgroundColor = UIColor(red: CGFloat(arc4random_uniform(256))/255.0, green: CGFloat(arc4random_uniform(256))/255.0, blue: CGFloat(arc4random_uniform(256))/255.0, alpha: 1.0)
    childVcs.append(vc)
}
```

4.创建SKPageView
```
let pageFrame = CGRect(x: 0, y: style.navigationBarHeight, width: view.bounds.width, height: view.bounds.height - style.navigationBarHeight)
let pageView = SKPageView(frame: pageFrame, style: style, titles: titles, childVcs: childVcs, parentVc: self)
pageView.backgroundColor = UIColor.blue
view.addSubview(pageView)
```
