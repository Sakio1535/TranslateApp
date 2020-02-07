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
    var sentenceManager = SentenceManager()
    
    var translateMode = true    //trueがかな、falseがカナ
    
    var mainTextView = UITextView()
    var catImage = UIImageView()
    var translateButton = UIButton()
    var deleteButton = UIButton()
    var selectButton = UISegmentedControl(items: ["かな", "カナ"])
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        sentenceManager.delegate = self    //デリゲート
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
        //起動後、即キーボード表示
        self.mainTextView.becomeFirstResponder()
        
        //猫の配置
        catImage.frame = CGRect(x: mainTextView.frame.origin.x,
                                y: mainTextView.frame.origin.y + mainTextView.frame.height + 20,
                                width: 100,
                                height: 100)
        catImage.image = UIImage(named: "cat-0")
        self.view.addSubview(catImage)
        
        //変換buttonの配置
        translateButton.frame = CGRect(x: catImage.frame.origin.x + catImage.frame.width + 20,
                                       y: catImage.frame.origin.y + 30,
                                       width: 200,
                                       height: 70)
        translateButton.layer.cornerRadius = 5
        translateButton.layer.borderWidth = 4
        translateButton.setBackgroundImage(UIImage(named: "font-0"), for: .normal)
        translateButton.setBackgroundImage(UIImage(named: "font-shadow-0"), for: .highlighted)
        self.view.addSubview(translateButton)
        translateButton.addTarget(self, action: #selector(translateSentence(_:)), for: .touchUpInside)
        
        //消去buttonの配置
        deleteButton.frame = CGRect(x: self.view.frame.width - 20 - 40,
                                    y: mainTextView.frame.origin.y + mainTextView.frame.height + 10,
                                    width: 20,
                                    height: 20)
        deleteButton.setImage(UIImage(named: "delete"), for: .normal)
        self.view.addSubview(deleteButton)
        deleteButton.addTarget(self, action: #selector(deleteSentence(_:)), for: .touchUpInside)
        
        //かなカナ変更ボタン
        selectButton.frame = CGRect(x: catImage.frame.origin.x + catImage.frame.width + 20,
                                    y: catImage.frame.origin.y,
                                    width: 80,
                                    height: 20)
        selectButton.selectedSegmentIndex = 0
        selectButton.selectedSegmentTintColor = .lightGray
        self.view.addSubview(selectButton)
        selectButton.addTarget(self, action: #selector(changeMode(_:)), for: .valueChanged)
        
    }
    
    //MARK: - Functions
    //かな・カナ変換
    @objc func translateSentence(_ sender: UIButton) {
        if let myText = mainTextView.text {
            sentenceManager.getJson(inputText: myText, mode: translateMode)
        }
    }
    
    //入力の消去
    @objc func deleteSentence(_ sender: UIButton) {
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

extension TextViewController: SentenceManagerDelegate {
    
    func translateCompleted(_ kanaData: String) {
        DispatchQueue.main.async {
            self.mainTextView.text = kanaData
        }
    }
    
    func errorHappened(_ error: Error) {
        print(error)
    }
    
}

