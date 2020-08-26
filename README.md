# SKPageView


### swift5.1版 分类标题栏, 带下划线或者背景的标题栏


**带下划线分类标题栏**
<img src="https://github.com/honkerSK/SKPageView/tree/master/img/bottomLine.png" width="500" alt="SKPageView"></img>



**带背景分类标题栏**
<img src="https://github.com/honkerSK/SKPageView/tree/master/img/coverView.png" width="500" alt="SKPageView"></img>

**底部标题栏,类似直播礼物布局**
<img src="https://github.com/honkerSK/SKPageView/tree/master/img/bottomTitle.png" width="500" alt="SKPageView"></img>

**表情键盘布局**
<img src="https://github.com/honkerSK/SKPageView/tree/master/img/emojiKeyboard.png" width="500" alt="SKPageView"></img>


#### 一. 带下划线分类标题栏的用法:

首先拖入SKPageView文件夹中所有文件.

**顶部标题栏 用法举例, 可参考源码中 TopTitleViewController.swift:**
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

#### 二. 底部标题栏的用法:
**可参考源码中 BottomTitleViewController.swift**

+ 1.首先拖入SKPageView文件夹中所有文件.

+ 2.创建PageCollectionView
```
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
```

+ 3.实现SKPageCollectionViewDataSource数据源
+ 4.实现SKPageCollectionViewDelegate, 代理方法监听每个cell点击


#### 三.自定义表情键盘的用法:
**可参考源码中 EmoticonViewController.swift和EmoticonView.swift**
步骤同 底部标题栏的用法 类似

+ 注意: 底部适配问题, 表情键盘在屏幕底部显示,必须实现SKPageStyle的属性isBottomShow为true

```
// 1.创建SKPageCollectionView
let style = SKPageStyle()
style.normalColor = UIColor(r: 0, g: 0, b: 0)
//注意:如果在屏幕底部显示,必须实现该属性
style.isBottomShow = true
```

+ 并且弹出表情键盘View的高度要根据底部安全区域适配

```
/适配底部安全区域
let bottomSafeHeight: CGFloat = (UIApplication.shared.statusBarFrame.size.height > 21) ? 34 : 0 as CGFloat
let emoticonView = EmoticonView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 250 + bottomSafeHeight))
```


