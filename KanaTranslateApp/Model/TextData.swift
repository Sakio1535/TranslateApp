//
//  DataStock.swift
//  KanaTranslateApp
//
//  Created by Sakio on 2020/02/06.
//  Copyright © 2020 Ryosuke Osaki. All rights reserved.
//

import UIKit

struct PostData: Codable {
    var appId: String
    var requestId: String
    var sentence: String
    var outputType: String
}

struct ResponseData: Codable {
    var requestId: String
    var outputType: String
    var converted: String
}
