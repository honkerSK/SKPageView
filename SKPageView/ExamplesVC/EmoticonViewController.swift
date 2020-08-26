//
//  EmoticonViewController.swift
//  SKPageView
//
//  Created by sunke on 2020/8/26.
//  Copyright © 2020 KentSun. All rights reserved.
//
// 自定义表情键盘示例
import UIKit

class EmoticonViewController: UIViewController {

    var textField:UITextField!
    
    fileprivate lazy var emoticonView : EmoticonView = {
        //适配底部安全区域
        let bottomSafeHeight: CGFloat = (UIApplication.shared.statusBarFrame.size.height > 21) ? 34 : 0 as CGFloat
        let emoticonView = EmoticonView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 250 + bottomSafeHeight))
        return emoticonView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        let textField = UITextField(frame: CGRect(x: 50, y: 180, width: 250, height: 30))
        textField.borderStyle = .roundedRect
        view.addSubview(textField)
        self.textField = textField
        
        
        let changeBtn = UIButton(frame: CGRect(x: 275, y: 226, width: 40, height: 30))
        changeBtn.setTitle("切换", for: .normal)
        changeBtn.setTitleColor(.black, for: .normal)
        changeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        view.addSubview(changeBtn)
        changeBtn.addTarget(self, action: #selector(changeBtnClick), for: .touchUpInside)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textField.becomeFirstResponder()
    }
    
    
    @objc func changeBtnClick()  {
        textField.resignFirstResponder()
        textField.inputView = textField.inputView == nil ? emoticonView : nil
        textField.becomeFirstResponder()
    }

}
