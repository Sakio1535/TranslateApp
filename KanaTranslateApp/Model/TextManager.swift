//
//  SentenceManager.swift
//  KanaTranslateApp
//
//  Created by Sakio on 2020/02/06.
//  Copyright © 2020 Ryosuke Osaki. All rights reserved.
//

import UIKit

//MARK: - Delegate
protocol KanaTransitionDelegate {
    
    func translateCompleted(kanaData: String)
    func errorHappened(error: Error)
    
}

//MARK: - JSON Parse
struct TextManager {
    
    var delegate: KanaTransitionDelegate?  //デリゲート
    
    let gooURL = "https://labs.goo.ne.jp/api/hiragana"  //基本URL
    
    
    func getJson(inputText: String, mode: Bool) {
        let outputType = mode == true ? "hiragana" : "katakana"    //モード変換
        let postData = PostData(appId: "0e40a8b16d63bc45897dd9bcc1fe57a35da1186e4f190a78434d334cc64fa756",
                                requestId: "record003",
                                sentence: inputText,
                                outputType: outputType)
        
        let jsonEncoder = JSONEncoder()
        jsonEncoder.keyEncodingStrategy = .convertToSnakeCase
        if let encodedData = try? jsonEncoder.encode(postData) {
            var request = URLRequest(url: URL(string: gooURL)!)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = encodedData
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    self.delegate?.errorHappened(error: error)
                    return
                }
                //responseは保留
                if let checkedData = data {
                    //ここで解析済みのJSONデータ（ひらがな）を受け取る　& デリゲートでVCに渡す
                    if let kanaData = self.parseJson(checkedData) {
                        self.delegate?.translateCompleted(kanaData: kanaData)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJson(_ jsonData: Data) -> String? {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            let decodedData = try jsonDecoder.decode(ResponseData.self, from: jsonData)
            return decodedData.converted
        } catch {
            delegate?.errorHappened(error: error)
            return nil
        }
    }
    
}
