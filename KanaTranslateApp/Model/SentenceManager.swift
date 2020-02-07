//
//  SentenceManager.swift
//  KanaTranslateApp
//
//  Created by Sakio on 2020/02/06.
//  Copyright © 2020 Ryosuke Osaki. All rights reserved.
//

import UIKit

//MARK: - Delegate
protocol SentenceManagerDelegate {
    func translateCompleted(_ kanaData: String)
    func errorHappened(_ error: Error)
}

//MARK: - JSON Parse
struct SentenceManager {
    
    var delegate: SentenceManagerDelegate?  //デリゲート
    
    let gooURL = "https://labs.goo.ne.jp/api/hiragana"
    
    func getJson(inputText: String, mode: Bool) {
        let outputType = mode == true ? "hiragana" : "katakana"
        let postData = PostData(app_id: "0e40a8b16d63bc45897dd9bcc1fe57a35da1186e4f190a78434d334cc64fa756",
                                request_id: "record003",
                                sentence: inputText,
                                output_type: outputType)
        
        if let encodedData = try? JSONEncoder().encode(postData) {
            var request = URLRequest(url: URL(string: gooURL)!)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = encodedData
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    self.delegate?.errorHappened(error)
                    return
                }
                //responseは保留
                if let checkedData = data {
                    //ここで解析済みのJSONデータ（ひらがな）を受け取る　& デリゲートでVCに渡す
                    if let kanaData = self.parseJson(checkedData) {
                        self.delegate?.translateCompleted(kanaData)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJson(_ jsonData: Data) -> String? {
        do {
            let decodedData = try JSONDecoder().decode(ResponseData.self, from: jsonData)
            return decodedData.converted
        } catch {
            delegate?.errorHappened(error)
            return nil
        }
    }
    
}
