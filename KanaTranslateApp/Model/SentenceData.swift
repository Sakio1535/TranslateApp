//
//  DataStock.swift
//  KanaTranslateApp
//
//  Created by Sakio on 2020/02/06.
//  Copyright © 2020 Ryosuke Osaki. All rights reserved.
//

import UIKit

struct PostData: Codable {
    var app_id: String
    var request_id: String
    var sentence: String
    var output_type: String
}

struct ResponseData: Codable {
    var request_id: String
    var output_type: String
    var converted: String
}
