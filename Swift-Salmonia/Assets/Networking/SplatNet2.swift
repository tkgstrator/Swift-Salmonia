//
//  SplatNet2.swift
//  Swift-Salmonia
//
//  Created by devonly on 2020-08-03.
//  Copyright © 2020 devonly. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import RealmSwift

class SplatNet2 {
    class func getSessionToken(session_token_code: String, session_token_code_verifier: String, complition: @escaping (JSON) -> ()) {
        let url = "https://salmonia.mydns.jp/api/session_token"
        let header: HTTPHeaders = [
            "User-Agent": "Salmonia iOS"
        ]
        let body = [
            "session_token_code": session_token_code,
            "session_token_code_verifier": session_token_code_verifier
        ]
        AF.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: header)
            .validate(contentType: ["application/json"])
            .responseJSON{ response in
                switch response.result {
                case .success(let value):
                    complition(JSON(value))
                case .failure:
                    break
                }
        }
    }
    
    class func getAccessToken(session_token: String, complition: @escaping (JSON) -> ()) {
        let url = "https://salmonia.mydns.jp/api/access_token"
        let header: HTTPHeaders = [
            "User-Agent": "Salmonia iOS"
        ]
        let body = [
            "session_token": session_token
        ]
        
        AF.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: header)
            .validate(contentType: ["application/json"])
            .responseJSON{ response in
                switch response.result {
                case .success(let value):
                    complition(JSON(value))
                case .failure:
                    break
                }
        }
    }
    
    class func callFlapgAPI(access_token: String, type: String, complition: @escaping (JSON) -> ()) {
        let url = "https://salmonia.mydns.jp/api/login"
        let header: HTTPHeaders = [
            "User-Agent": "Salmonia iOS"
        ]
        let body = [
            "access_token": access_token,
            "type": type
        ]
        
        AF.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: header)
            .validate(contentType: ["application/json"])
            .responseJSON{ response in
                switch response.result {
                case .success(let value):
                    complition(JSON(value))
                case .failure:
                    break
                }
        }
    }
    
    class func getSplatoonToken(result: JSON, complition: @escaping (JSON) -> ()) {
        let url = "https://salmonia.mydns.jp/api/splatoon_token"
        let header: HTTPHeaders = [
            "User-Agent": "Salmonia iOS"
        ]
        // ここもっと簡単に書けるだろ
        let body = [
            "f": result["f"].stringValue,
            "p1": result["p1"].stringValue,
            "p2": result["p2"].stringValue,
            "p3": result["p3"].stringValue
        ]
        
        AF.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: header)
            .validate(contentType: ["application/json"])
            .responseJSON{ response in
                switch response.result {
                case .success(let value):
                    complition(JSON(value))
                case .failure(let error):
                    debugPrint(error)
                    break
                }
        }
    }
    
    class func getSplatoonAccessToken(result: JSON, splatoon_token: String, complition: @escaping (JSON) -> ()) {
        let url = "https://salmonia.mydns.jp/api/splatoon_access_token"
        let header: HTTPHeaders = [
            "User-Agent": "Salmonia iOS"
        ]
        // ここもっと簡単に書けるだろ
        let body = [
            "parameter" : [
                "f": result["f"].stringValue,
                "p1": result["p1"].stringValue,
                "p2": result["p2"].stringValue,
                "p3": result["p3"].stringValue
            ],
            "splatoon_token": splatoon_token
            ] as [String : Any]
        
        AF.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: header)
            .validate(contentType: ["application/json"])
            .responseJSON{ response in
                switch response.result {
                case .success(let value):
                    complition(JSON(value))
                case .failure(let error):
                    debugPrint(error)
                    break
                }
        }
    }
    
    class func getIksmSession(splatoon_access_token: String, complition: @escaping (JSON) -> ()) {
        let url = "https://salmonia.mydns.jp/api/iksm_session"
        let header: HTTPHeaders = [
            "User-Agent": "Salmonia iOS"
        ]
        let body = [
            "splatoon_access_token": splatoon_access_token
        ]
        
        AF.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: header)
            .validate(contentType: ["application/json"])
            .responseJSON{ response in
                switch response.result {
                case .success(let value):
                    complition(JSON(value))
                    //                    iksm_session = JSON(value)["iksm_session"].stringValue
                    //                    nsaid = JSON(value)["nsaid"].stringValue
                    //                    SplatNet2.setUserInfoFromSplatNet2()
                //                    debugPrint("IKSM SESSION", iksm_session)
                case .failure(let error):
                    debugPrint(error)
                    break
                }
        }
    }
    
    class func getResultFromSplatNet2(job_id: Int, complition: @escaping (JSON) -> ()) {
        guard let realm = try? Realm() else { return }
        guard let iksm_session: String = realm.objects(UserInfoRealm.self).first?.iksm_session else { return }
        //        guard let api_token: String = realm.objects(UserInfoRealm.self).first?.api_token else { return }
        
        let url = "https://app.splatoon2.nintendo.net/api/coop_results/" + String(job_id)
        let header: HTTPHeaders = [
            "cookie" : "iksm_session=" + iksm_session
        ]
        
        AF.request(url, method: .get, headers: header)
            .validate(contentType: ["application/json"])
            .responseJSON{ response in
                switch response.result {
                case .success(let value):
                    complition(JSON(value))
                    //                    uploadResultToSalmonStats(result: JSON(value), token: api_token)
                    break
                case .failure(let error):
                    print(error)
                }
        }
    }
    
    class func getSummaryFromSplatNet2(completion: @escaping (JSON) -> ()) {
        guard let realm = try? Realm() else { return }
        guard let iksm_session: String = realm.objects(UserInfoRealm.self).first?.iksm_session else { return }
        
        let url = "https://app.splatoon2.nintendo.net/api/coop_results"
        let header: HTTPHeaders = [
            "cookie" : "iksm_session=" + iksm_session
        ]
        
        AF.request(url, method: .get, headers: header)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseJSON{ response in
                switch response.result {
                case .success(let value):
                    print("GET SUCCESS")
                    completion(JSON(value))
                case .failure(let error):
                    print("REGENERATE")
                    print(error)
                    SplatNet2.genIksmSession() { response in
                        completion(response)
                    }
                }
        }
    }
    
    class func genIksmSession(complition: @escaping (JSON) -> ()) {
        guard let realm = try? Realm() else { return }
        guard let session_token: String = realm.objects(UserInfoRealm.self).first?.session_token else { return }
        guard let user = realm.objects(UserInfoRealm.self).first else { return }
        
        SplatNet2.getAccessToken(session_token: session_token) { response in
            let access_token = response["access_token"].stringValue
            SplatNet2.callFlapgAPI(access_token: access_token, type: "nso") { response in
                SplatNet2.getSplatoonToken(result: response) { response in
                    let splatoon_token = response["splatoon_token"].stringValue
                    let username = response["user"]["name"].stringValue
                    let imageUri = response["user"]["image"].stringValue
                    SplatNet2.callFlapgAPI(access_token: splatoon_token, type: "app") { response in
                        SplatNet2.getSplatoonAccessToken(result: response, splatoon_token: splatoon_token) { response in
                            let splatoon_access_token = response["splatoon_access_token"].stringValue
                            SplatNet2.getIksmSession(splatoon_access_token: splatoon_access_token) { response in
                                let iksm_session = response["iksm_session"].stringValue
                                try? realm.write {
                                    user.setValue(iksm_session, forKey: "iksm_session")
                                    user.setValue(username, forKey: "name")
                                    user.setValue(imageUri, forKey: "image")
                                }
                                SplatNet2.getSummaryFromSplatNet2() { response in
                                    complition(response)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    class func getPlayerNickname(nsaid: String, complition: @escaping (JSON) -> ()) {
        guard let iksm_session: String = try? Realm().objects(UserInfoRealm.self).first?.iksm_session else { return }
        
        let url = "https://app.splatoon2.nintendo.net/api/nickname_and_icon?id=" + nsaid
        let header: HTTPHeaders = [
            "cookie" : "iksm_session=" + iksm_session
        ]
        
        AF.request(url, method: .get, headers: header).responseJSON { response in
            switch response.result {
            case .success(let value):
                complition(JSON(value))
                break
            case .failure(let error):
                print(error)
            }
        }
    }
}
