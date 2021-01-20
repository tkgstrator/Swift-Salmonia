//
//  Modifier.swift
//  Salmonia2
//
//  Created by devonly on 2020-09-22.
//

import Foundation
import SwiftUI
import URLImage
import RealmSwift
import WebKit


extension Image {
    func Modifier(_ isEnabled: Bool = true) -> some View {
        self
            .resizable()
            .scaledToFit()
            .foregroundColor(isEnabled ? .white : .cGray)
            .frame(width: 25, height: 25)
    }
}

struct Splatfont: ViewModifier {
    let size: CGFloat
    
    func body(content: Content) -> some View {
        if NSLocale.preferredLanguages[0].prefix(2) == "zh" {
            return
                content
                .font(.custom("FZYHFW--GB1-0", size: size + 4))
//                .minimumScaleFactor(0.7)
        } else {
            return
                content
                .font(.custom("Splatfont", size: size))
//                .minimumScaleFactor(0.7)
        }
    }
}

struct Splatfont2: ViewModifier {
    let size: CGFloat
    
    func body(content: Content) -> some View {
        if NSLocale.preferredLanguages[0].prefix(2) == "zh" {
            return
                content
                .font(.custom("FZYHFW--GB1-0", size: size))
                .minimumScaleFactor(0.7)
                .lineLimit(1)
        } else {
            return
                content
                .font(.custom("Splatfont2", size: size))
                .minimumScaleFactor(0.7)
                .lineLimit(1)
        }
        //            .frame(height: size)
    }
}

//struct WebKitView: View {
//    var body: some View {
//        WebView(request: URLRequest(url: URL(string: "https://salmon-stats-api.yuki.games/auth/twitter")!))
//            .navigationBarTitle("SalmonStats")
//            .navigationBarItems(trailing: login)
//    }
//    
//    // 通知を出す
//    func notification(title: Notification, message: Notification) {
//        
//        let content = UNMutableNotificationContent()
//        content.title = title.localizedDescription.localized
//        content.body = message.localizedDescription.localized
//        content.sound = UNNotificationSound.default
//        
//        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
//        UNUserNotificationCenter.current().add(request)
//    }
//    
//    func notification(title: Notification, error: Error) {
//        
//        let content = UNMutableNotificationContent()
//        content.title = title.localizedDescription.localized
//        content.body = error.localizedDescription.localized
//        content.sound = UNNotificationSound.default
//        
//        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
//        UNUserNotificationCenter.current().add(request)
//    }
//    
//    
//    private var login: some View {
//        Button(action: {
//            WKWebView().configuration.websiteDataStore.httpCookieStore.getAllCookies {
//                cookies in
//                for cookie in cookies {
//                    if cookie.name == "laravel_session" {
//                        let laravel_session = cookie.value
//                        do {
//                            let api_token = try SalmonStats.getAPIToken(laravel_session)
//                            let user = realm.objects(SalmoniaUserRealm.self)
//                            try? realm.write { user.setValue(api_token, forKey: "api_token")}
//                            notification(title: .success, message: .laravel)
//                            return
//                        } catch  {
//                            notification(title: .failure, error: error)
//                        }
//                    }
//                }
////                notification(title: .failure, message: .laravel)
//            }
//        }) {
//            Image(systemName: "snow").resizable().foregroundColor(Color.blue).scaledToFit().frame(width: 25, height: 25)
//        }
//    }
//}
