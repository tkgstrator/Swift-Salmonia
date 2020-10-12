//
//  CrewSearchView.swift
//  Salmonia2
//
//  Created by devonly on 2020-10-11.
//

import SwiftUI
import SwiftyJSON
import SplatNet2
import URLImage
import RealmSwift

struct CrewSearchView: View {
    @EnvironmentObject var user: SalmoniaUserCore
    @State var players: [Player] = []
    @State var nickname: String = ""
    @State var isDisabled: Bool = false
    
    struct Player: Hashable {
        let id: Int?
        let nickname: String
        let thumbnail_url: String
        let registered: Bool
        let nsaid: String
        
        init(player: JSON) {
            id = player["id"].int
            nickname = player["nickname"].stringValue
            thumbnail_url = player["thumbnail_url"].stringValue
            registered = player["registered"].boolValue
            nsaid = player["nsaid"].stringValue
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                TextField("Enter user name", text: $nickname).multilineTextAlignment(.center)
                searchButton
                Spacer()
            }.font(.custom("Roboto Mono", size: 22))
            Divider()
            List {
                ForEach(players, id:\.self) { player in
                    NavigationLink(destination: SalmonStatsView().environmentObject(CrewInfoCore(player.nsaid))) {
                        HStack {
                            URLImage(URL(string: player.thumbnail_url)!, content: { $0.image.resizable().clipShape(RoundedRectangle(cornerRadius: 8.0))})
                                .frame(width: 50, height: 50)
                            Text(player.nickname).frame(maxWidth: .infinity)
                            if player.registered {
                                Image(systemName: "checkmark.seal.fill").resizable().aspectRatio(contentMode: .fit).frame(width: 20).foregroundColor(.cBlue)
                            } else {
                                Text("").frame(width: 20)
                            }
                        }
                    }
                    .onAppear() {
                        SalmonStats.getPlayerOverView(nsaid: player.nsaid)
                    }
                }.modifier(Splatfont(size: 18))
            }
        }
        .navigationBarTitle("Crew Search")
        .padding(.horizontal, 10)
    }
    
    private var searchButton: some View {
        Button(action: { searchPlayer(keyword: nickname) }) { Image(systemName: "magnifyingglass").resizable().scaledToFit().frame(width: 30, height: 30).disabled(isDisabled) }
    }
    
    private func searchPlayer(keyword: String) {
        do {
            guard let iksm_session = user.account.first?.iksm_session else { throw APIError.Response("", "") }
            DispatchQueue(label: "Search").async {
                do {
                    isDisabled.toggle()
                    if keyword.isEmpty { throw APIError.Response("", "") }
                    players.removeAll()

                    let url = "https://salmon-stats-api.yuki.games/api/players/search?name=\(keyword.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)"
                    let realm = try Realm()
                    var response = try SAF.request(url)
                    var _users = response["users"].map({$0.1})
                    _users.append(contentsOf: response["names"].map({$0.1}))
                    let nsaids: [String] = Array(_users.map({ $0["player_id"].stringValue }).prefix(5))
                    
                    // 任天堂公式APIからデータを取得
                    response = try SplatNet2.getPlayerNickName(nsaids, iksm_session: iksm_session)
                    let nicknames = response["nickname_and_icons"]
                    
                    realm.beginWrite()
                    for (_, nickname) in nicknames {
                        let name = nickname["nickname"].stringValue
                        let image = nickname["thumbnail_url"].stringValue
                        let nsaid = nickname["nsa_id"].stringValue
                        realm.create(CrewInfoRealm.self, value: CrewInfoRealm(name: name, image: image, nsaid: nsaid), update: .all)
                        let json = JSON(_users.filter({ $0["player_id"].stringValue == nsaid}).last.map({ ["id": $0["id"].int, "nsaid": nsaid, "registered": $0["id"].int != nil, "nickname": name, "thumbnail_url": image] }))
                        players.append(Player(player: json))
                    }
                    try realm.commitWrite()
                    isDisabled.toggle()
                } catch {
                    isDisabled.toggle()
                }
            }
        } catch {
            isDisabled.toggle()
        }
    }
}

struct CrewSearchView_Previews: PreviewProvider {
    static var previews: some View {
        CrewSearchView()
    }
}
