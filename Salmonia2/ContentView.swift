//
//  ContentView.swift
//  Salmonia2
//
//  Created by devonly on 2020-09-27.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var unlock: UnlockCore
    @EnvironmentObject var main: MainCore
    
    var body: some View {
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            NavigationView {
                TopMenu
            }
        case .pad:
            NavigationView {
                TopMenu
            }
        case .unspecified:
            EmptyView()
        case .tv:
            EmptyView()
        case .carPlay:
            EmptyView()
        case .mac:
            EmptyView()
        @unknown default:
            EmptyView()
        }
    }
    
    var TopMenu: some View {
        switch main.isLogin {
        case true:
            return AnyView(SalmoniaView())
        case false:
            return AnyView(LoginMenu())
        }
    }
    
    var BackGround: some View {
        LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .top, endPoint: .bottom)
            .edgesIgnoringSafeArea(.all)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
