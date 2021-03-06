//
//  ViewController.swift
//  KanaTranslateApp
//
//  Created by Sakio on 2020/02/05.
//  Copyright © 2020 Ryosuke Osaki. All rights reserved.
//

import UIKit

class TextViewController: UIViewController {
    
    //MARK: - Variables
        //外部から呼び出し
    var textManager = TextManager()
    var indicator = ActivityIndicator()
    
    var translateMode = true    //trueがかな、falseがカナ
    
    var catTimer = Timer()
    var count = 0
        //UI部品
    var mainTextView = UITextView()
    var catImageButton = UIButton()
    var catSecretImage = UIImageView()
    var translateButton = UIButton()
    var deleteButton = UIButton()
    var selectButton = UISegmentedControl(items: ["かな", "カナ"])
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        textManager.delegate = self    //デリゲート
        
        //textViewの配置
        mainTextView.frame = CGRect(x: 20,
                                    y: 70,
                                    width: self.view.frame.width - 40,
                                    height: self.view.frame.height * 0.3)
        mainTextView.layer.cornerRadius = 20
        mainTextView.layer.borderWidth = 3
        mainTextView.textAlignment = .left
        mainTextView.font = UIFont.systemFont(ofSize: 30)
        self.view.addSubview(mainTextView)
        
        //猫の配置
        catImageButton.frame = CGRect(x: mainTextView.frame.origin.x,
                                y: mainTextView.frame.origin.y + mainTextView.frame.height + 20,
                                width: 100,
                                height: 100)
        catImageButton.setImage(UIImage(named: "cat-0"), for: .normal)
            //ボタンタップ時の変化を無効化
        catImageButton.adjustsImageWhenHighlighted = false
        catImageButton.adjustsImageWhenDisabled = false
        self.view.addSubview(catImageButton)
        
        //シークレット猫の配置
        catSecretImage.frame = CGRect(x: self.view.frame.width - 80,
                                      y: self.view.frame.height - 80,
                                      width: 80,
                                      height: 80)
        catSecretImage.image = UIImage(named: "catSecret-0")
        self.view.addSubview(catSecretImage)
        
        //変換buttonの配置
        translateButton.frame = CGRect(x: catImageButton.frame.origin.x + catImageButton.frame.width + 20,
                                       y: catImageButton.frame.origin.y + 30,
                                       width: 200,
                                       height: 70)
        translateButton.layer.cornerRadius = 5
        translateButton.layer.borderWidth = 4
        translateButton.setBackgroundImage(UIImage(named: "font-0"), for: .normal)
        translateButton.setBackgroundImage(UIImage(named: "font-shadow-0"), for: .highlighted)
        self.view.addSubview(translateButton)
        
        //消去buttonの配置
        deleteButton.frame = CGRect(x: self.view.frame.width - 20 - 40,
                                    y: mainTextView.frame.origin.y + mainTextView.frame.height + 10,
                                    width: 30,
                                    height: 30)
        deleteButton.setImage(UIImage(named: "delete"), for: .normal)
        self.view.addSubview(deleteButton)
        
        //かなカナ変更ボタン
        selectButton.frame = CGRect(x: catImageButton.frame.origin.x + catImageButton.frame.width + 20,
                                    y: catImageButton.frame.origin.y,
                                    width: 80,
                                    height: 20)
        selectButton.selectedSegmentIndex = 0
        selectButton.selectedSegmentTintColor = .lightGray
        self.view.addSubview(selectButton)
        
        //Event & Action
        self.mainTextView.becomeFirstResponder()    //起動時、キーボード表示
        catImageButton.addTarget(self, action: #selector(startAnimation(_:)), for: .touchUpInside)
        translateButton.addTarget(self, action: #selector(translateText(_:)), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(deleteText(_:)), for: .touchUpInside)
        selectButton.addTarget(self, action: #selector(changeMode(_:)), for: .valueChanged)
        
    }
    
    //MARK: - Functions
    //猫のアニメーション
    @objc func startAnimation(_ sender: UIButton) {
        catImageButton.isEnabled = false
        
        catTimer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(catAnimation), userInfo: nil, repeats: true)
    }
    @objc func catAnimation() {
        count += 1
        
        catImageButton.setImage(UIImage(named: "cat-\(count)"), for: .normal)
        if count > 4 {
            count = 0
            catImageButton.setImage(UIImage(named: "cat-\(count)"), for: .normal)
            catImageButton.isEnabled = true
            catTimer.invalidate()
        }
    }
    
    //かな・カナ変換
    @objc func translateText(_ sender: UIButton) {
        if let myText = mainTextView.text {
            textManager.getJson(inputText: myText, mode: translateMode)
            //インディケーター表示
            indicator.showIndicator(view: self.view)
        }
    }
    //入力の消去
    @objc func deleteText(_ sender: UIButton) {
        mainTextView.text = ""
    }
    
    //かな・カナ、モード変換
    @objc func changeMode(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            translateMode = true
            translateButton.setBackgroundImage(UIImage(named: "font-0"), for: .normal)
            translateButton.setBackgroundImage(UIImage(named: "font-shadow-0"), for: .highlighted)
        case 1:
            translateMode = false
            translateButton.setBackgroundImage(UIImage(named: "font-1"), for: .normal)
            translateButton.setBackgroundImage(UIImage(named: "font-shadow-1"), for: .highlighted)
        default:
            return
        }
    }
}

//MARK: - Delegate

extension TextViewController: KanaTransitionDelegate {
    
    //値の受け取り
    func translateCompleted(kanaData: String) {
        //処理感出すために0.3秒遅らせて実行
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
            self.mainTextView.text = kanaData
            //インディケーター非表示
            self.indicator.hideIndicator()
        }
    }
    //ここでエラー処理
    func errorHappened(error: Error) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
            self.mainTextView.text = "変換に失敗しました"
            self.indicator.hideIndicator()
        }
    }
    
}
