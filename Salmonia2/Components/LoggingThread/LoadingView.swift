//
//  LoadingView.swift
//  Salmonia2
//
//  Created by devonly on 2020-09-22.
//

import SwiftUI
import RealmSwift
import Alamofire
import SplatNet2
import SwiftyJSON

struct LoadingView: View {
    @EnvironmentObject var user: UserInfoCore
    @EnvironmentObject var main: MainCore
    @Environment(\.presentationMode) var present
    
    @State var mainlog: ProgressLog = ProgressLog()
    @State var isPresented: Bool = false
    @State var appError: CustomNSError?
    
    var body: some View {
        LoggingThread(log: $mainlog)
            .alert(isPresented: $isPresented, error: appError)
            .onChange(of: isPresented) { value in
                DispatchQueue.main.async { self.present.wrappedValue.dismiss() }
            }
            .onAppear {
                // TODO: エラーを出力するように変更する
                guard let api_token: String = user.api_token else { return }
                guard let version: String = user.version else { return }
                guard let session_token: String = user.session_token else { return }
                guard let nsaid: String = user.nsaid else { return }

                DispatchQueue(label: "LoadingView").async {
                    do {
                        // TODO: ここでいろいろエラー発生させて検証
                        #if DEBUG
                        throw APPError.coop
                        #endif
                        
                        // DispatchQueue内では別にオブジェクトを用意する必要がある
                        guard let realm = try? Realm() else { return }
                        // イカスミセッションが切れていた場合
                        if !SplatNet2.isValid(iksm_session: user.iksm_session!) {
                            let response: JSON = try SplatNet2.genIksmSession(user.session_token!, version: user.version!)
                            user.iksm_session = response["iksm_session"].string
                        }
                        // シフトデータを取得
                        let summary: JSON = try SplatNet2.getSummary(iksm_session: user.iksm_session!)
                        guard var dict_summary: [String: Any] = summary["summary"]["card"].dictionaryObject else { throw APPError.coop } // とりあえず適当なエラーを吐く
                        dict_summary.updateValue(nsaid, forKey: "nsaid") // データにプレイヤーIDを追加

                        guard let remote_job_num: Int = summary["summary"]["card"]["job_num"].int else { return }
                        // TODO: ここもエラー表示に対応したい
                        #if DEBUG
                        let job_num: Range<Int> = Range(max(remote_job_num - 49, remote_job_num - 25) ... remote_job_num)
                        #else
                        if user.job_num == remote_job_num { throw APPError.empty }
                        let job_num: Range<Int> = Range(max(remote_job_num - 49, user.job_num + 1) ... remote_job_num)
                        #endif
                        
                        // リザルト取得に必要な変数
                        var results: [JSON] = []
                        var salmon_ids: [(Int, Int)] = [] // Salmon StatsのIDとの整合性をとる
                        let times: [Int] = realm.objects(CoopResultsRealm.self).map({ $0.play_time })
                        
                        // リザルトを取得
                        for (idx, job_id) in job_num.enumerated() {
                            mainlog.progress = CGFloat(idx + 1) / CGFloat(job_num.count)
                            results.append(try SplatNet2.getResult(job_id: job_id, iksm_session: user.iksm_session!))
                        }
                        
                        // 10件ずつアップロードする
                        let dict_results: [[Dictionary<String, Any>]] = results.map{ $0.dictionaryObject! }.chunked(by: 10)
                        for result in dict_results {
                            mainlog.progress += 1 / CGFloat(dict_results.count)
                            let response: JSON = try SalmonStats.uploadSalmonStats(token: api_token, result)
                            let ids: [(Int, Int)] = response.map{ ($0.1["job_id"].intValue, $0.1["salmon_id"].intValue) }
                            salmon_ids.append(contentsOf: ids)
                            Thread.sleep(forTimeInterval: 5)
                        }
                        
                        // データベースに書き込むデータを作成
                        realm.beginWrite()
                        var nsaids: [String] = [] // 必要なIDたち
                        for result in results {
                            let others: JSON = result["other_results"]
                            nsaids.append(contentsOf: others.map({ $0.1["pid"].stringValue }))
                            let job_id: Int = result["job_id"].intValue
                            let salmon_id: Int? = salmon_ids.filter({ $0.0 == job_id }).first.map({ $0.1 })
                            let result: CoopResultsRealm = JF.FromSplatNet2(nsaid: nsaid, salmon_id: salmon_id, result)
                            let time: [Int] = times.filter({ abs($0 - result.play_time) < 10 })
                            switch time.isEmpty {
                            case true:
                                realm.create(CoopResultsRealm.self, value: result, update: .modified)
                            case false:
                                let record = realm.objects(CoopResultsRealm.self).filter("play_time=%@", time.first!)
                                record.setValue(result.job_id, forKey: "job_id")
                                record.setValue(result.grade_point, forKey: "grade_point")
                                record.setValue(result.grade_id, forKey: "grade_id")
                                record.setValue(result.grade_point_delta, forKey: "grade_point_delta")
                            }
                        }
                        nsaids.append(nsaid) // 自身のIDも追加
                        let crews: JSON = try SplatNet2.getPlayerNickName(Array(Set(nsaids)), iksm_session: user.iksm_session!) // マッチングした仲間のデータを取得
                        for (_, crew) in crews["nickname_and_icons"] {
                            let value: [String: Any] = ["nsaid": crew["nsa_id"].stringValue, "name": crew["nickname"].stringValue, "image": crew["thumbnail_url"].stringValue]
                            realm.create(CrewInfoRealm.self, value: value, update: .all)
                        }

                        // TODO: ここで更新しないと取得漏れが発生する
                        // データベースのデータを更新する
                        realm.create(UserInfoRealm.self, value: dict_summary as Any, update: .modified)
                        try realm.commitWrite()
                        // TODO: ここで処理が終わったので画面を戻す
                        DispatchQueue.main.async { self.present.wrappedValue.dismiss() }
                    } catch {
                        appError = error as? CustomNSError
                        isPresented.toggle()
                    }
                }
            }
    }
}
