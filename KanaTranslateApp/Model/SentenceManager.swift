//
//  SentenceManager.swift
//  KanaTranslateApp
//
//  Created by Sakio on 2020/02/06.
//  Copyright © 2020 Ryosuke Osaki. All rights reserved.
//

import UIKit

struct SentenceManager {
    
    let gooURL = "https://labs.goo.ne.jp/api/hiragana"
    
    func getJson(inputText: String) {
        
        let postData = PostData(app_id: "0e40a8b16d63bc45897dd9bcc1fe57a35da1186e4f190a78434d334cc64fa756",
                                request_id: "record003",
                                sentence: inputText,
                                output_type: "hiragana")
        if let encodedData = try? JSONEncoder().encode(postData) {
            var request = URLRequest(url: URL(string: gooURL)!)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = encodedData
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {print("error: \(error)"); return}
                if let safeData = data {
                    if let decodedData = try? JSONDecoder().decode(ResponseData.self, from: safeData) {
                        print(decodedData.converted)
                    }
                }
            }
        task.resume()
        }
    }
    
}
