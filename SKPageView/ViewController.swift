//
//  ViewController.swift
//  SKPageView
//
//  Created by sunke on 2020/7/9.
//  Copyright © 2020 KentSun. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    
    // MARK: 重写的函数
    override func viewDidLoad() {
        super.viewDidLoad()
        
        automaticallyAdjustsScrollViewInsets = false
        
        let topBtn = UIButton(type: .custom)
        topBtn.setTitle("顶部分类标题栏示例", for: .normal)
        topBtn.setTitleColor(.blue, for: .normal)
        topBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        topBtn.frame = CGRect(x: 100, y: 200, width: 180, height: 50)
        topBtn.addTarget(self, action: #selector(pushTopTitleVC), for: .touchUpInside)
        view.addSubview(topBtn)
        
        
        let bottomBtn = UIButton(type: .custom)
        bottomBtn.setTitle("底部分类标题栏", for: .normal)
        bottomBtn.setTitleColor(.blue, for: .normal)
        bottomBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        bottomBtn.frame = CGRect(x: 100, y: 300, width: 180, height: 50)
        bottomBtn.addTarget(self, action: #selector(pushBottomTitleVC), for: .touchUpInside)
        view.addSubview(bottomBtn)
        
        let emoticonBtn = UIButton(type: .custom)
        emoticonBtn.setTitle("表情键盘", for: .normal)
        emoticonBtn.setTitleColor(.blue, for: .normal)
        emoticonBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        emoticonBtn.frame = CGRect(x: 100, y: 400, width: 180, height: 50)
        emoticonBtn.addTarget(self, action: #selector(pushEmoticonVC), for: .touchUpInside)
        view.addSubview(emoticonBtn)
        
    }
    
    @objc func pushTopTitleVC() {
        let topTitleVC = TopTitleViewController()
        self.navigationController?.pushViewController(topTitleVC, animated: true)
        
    }
    
    @objc func pushBottomTitleVC() {
        let bottomTitleVC = BottomTitleViewController()
        self.navigationController?.pushViewController(bottomTitleVC, animated: true)
    }
    
    @objc func pushEmoticonVC() {
        let emoticonVC = EmoticonViewController()
        self.navigationController?.pushViewController(emoticonVC, animated: true)
    }
    
}





