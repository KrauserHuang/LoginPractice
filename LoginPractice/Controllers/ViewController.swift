//
//  ViewController.swift
//  LoginPractice
//
//  Created by Tai Chin Huang on 2021/3/23.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isTranslucent = false
        let fullScreenSize = UIScreen.main.bounds.size
        // 使用 UIButton(frame:) 建立一個 UIButton，大小、圓邊、背景顏色
//        var signInButton = UIButton()
        let signInButton = UIButton(frame: CGRect(x: 0, y: 0, width: 320, height: 54))
        signInButton.layer.cornerRadius = signInButton.frame.height / 2
        signInButton.backgroundColor = .white
        // 按鈕文字、大小、顏色
        signInButton.setTitle("Sing in", for: .normal)
        signInButton.titleLabel?.font = .systemFont(ofSize: 18)
        signInButton.setTitleColor(.black, for: .normal)
        // 按鈕是否可以使用、按下後的動作
        signInButton.isEnabled = true
        signInButton.addTarget(self, action: #selector(clickButton), for: .touchUpInside)
        // 設置位置並加入畫面
        signInButton.center = CGPoint(x: fullScreenSize.width * 0.5, y: fullScreenSize.height * 0.75)
        self.view.addSubview(signInButton)
    }
    
    @objc func clickButton() {
        // 為基底的 self.view 的底色在黑色與白色兩者間切換
        if self.view.backgroundColor!.isEqual(UIColor.black) {
            self.view.backgroundColor = .white
        } else {
            self.view.backgroundColor = .black
        }
    }
    
}

