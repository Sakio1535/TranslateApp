//
//  ViewController.swift
//  KanaTranslateApp
//
//  Created by Sakio on 2020/02/05.
//  Copyright © 2020 Ryosuke Osaki. All rights reserved.
//

import UIKit

class TextViewController: UIViewController {
    
    var sentenceManager = SentenceManager()
    
    var mainTextView = UITextView()
    var catImage = UIImageView()
    var explainTextView = UITextView()
    var translateButton = UIButton()
    var deleteButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//MARK: - Position Settings
        //textViewの配置
        mainTextView.frame = CGRect(x: 20,
                                    y: 70,
                                    width: self.view.frame.width - 40,
                                    height: self.view.frame.height / 4)
        mainTextView.layer.cornerRadius = 20
        mainTextView.layer.borderWidth = 3
        mainTextView.textAlignment = .left
        mainTextView.font = UIFont.systemFont(ofSize: 30)
        self.view.addSubview(mainTextView)
        
        //imageViewの配置
        catImage.frame = CGRect(x: 20,
                                y: 70 + mainTextView.frame.height + 20,
                                width: 100,
                                height: 100)
        catImage.image = UIImage(named: "cat-1")
        self.view.addSubview(catImage)
        
        //textView2の配置
        explainTextView.frame = CGRect(x: 20 + 100 + 5,
                                       y: catImage.frame.origin.y + 20,
                                       width: 120,
                                       height: 60)
        explainTextView.layer.cornerRadius = 15
        explainTextView.layer.borderWidth = 2
        explainTextView.textAlignment = .center
        explainTextView.textContainerInset = UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
        explainTextView.font = UIFont.systemFont(ofSize: 15)
        explainTextView.text = "漢字 → かな"
        explainTextView.isEditable = false
        self.view.addSubview(explainTextView)
        
        //変換buttonの配置
        translateButton.frame = CGRect(x: explainTextView.frame.origin.x + 120 + 10,
                                       y: catImage.frame.origin.y,
                                       width: 80,
                                       height: 60)
        translateButton.layer.cornerRadius = 5
        translateButton.layer.borderWidth = 2
        translateButton.layer.shadowOpacity = 0.5
        translateButton.layer.shadowOffset = CGSize(width: 1, height: 1)
        translateButton.backgroundColor = .white
        translateButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        translateButton.setTitleColor(.blue, for: .normal)
        translateButton.setTitle("変換！", for: .normal)
        self.view.addSubview(translateButton)
        translateButton.addTarget(self, action: #selector(translateSentence(_:)), for: .touchUpInside)
        
        //消去buttonの配置
        deleteButton.frame = CGRect(x: explainTextView.frame.origin.x + 120 + 10,
                                    y: catImage.frame.origin.y + 60 + 10,
                                    width: 80,
                                    height: 30)
        deleteButton.layer.cornerRadius = 5
        deleteButton.layer.borderWidth = 2
        deleteButton.layer.shadowOpacity = 0.5
        deleteButton.layer.shadowOffset = CGSize(width: 1, height: 1)
        deleteButton.backgroundColor = .white
        deleteButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        deleteButton.setTitleColor(.red, for: .normal)
        deleteButton.setTitle("消去！", for: .normal)
        self.view.addSubview(deleteButton)
        deleteButton.addTarget(self, action: #selector(deleteSentence(_:)), for: .touchUpInside)
        
    }
    
//MARK: - Functions
    
    @objc func translateSentence(_ sender: UIButton) {
        //入力があるならば
        if let myText = mainTextView.text {
            sentenceManager.getJson(inputText: myText)
        }
        
    }
    
    
    
    
    
    
    
    @objc func deleteSentence(_ sender: UIButton) {
        mainTextView.text = ""
    }
    
    
}

