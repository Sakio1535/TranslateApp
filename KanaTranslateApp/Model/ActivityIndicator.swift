//
//  Indicator.swift
//  KanaTranslateApp
//
//  Created by Sakio on 2020/02/10.
//  Copyright © 2020 Ryosuke Osaki. All rights reserved.
//

import UIKit

struct ActivityIndicator {
    
    var indicator = UIActivityIndicatorView()
    var indicatorBackView = UIView()
    
    func showIndicator(view: UIView) {
        indicator.frame = CGRect(x: 0,
                                 y: 0,
                                 width: 100,
                                 height: 100)
        indicator.center = view.center
        indicator.style = .large
        indicator.color = .black
        indicator.hidesWhenStopped = true
        view.addSubview(indicator)
        
        indicatorBackView.frame = CGRect(x: 0,
                                         y: 0,
                                         width: view.frame.width,
                                         height: view.frame.height)
        indicatorBackView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        indicatorBackView.isUserInteractionEnabled = true
        view.addSubview(indicatorBackView)
        
        indicator.startAnimating()
    }
    
    func hideIndicator() {
        indicator.stopAnimating()
        indicatorBackView.removeFromSuperview()
    }
    
}
