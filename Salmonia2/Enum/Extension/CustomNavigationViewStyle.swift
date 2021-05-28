//
//  CustomNavigationViewStyle.swift
//  Salmonia2
//
//  Created by Devonly on 2021/03/09.
//

import Foundation
import SwiftUI
 
public struct LegacyNavigationViewStyle: NavigationViewStyle {
    struct ControllerModifier: ViewModifier {
        struct ControllerView: UIViewControllerRepresentable {
            class ViewController: UIViewController {
                
                override func viewDidAppear(_ animated: Bool) {
                    super.viewDidAppear(animated)
                    guard let svc = self.parent?.children.first as? UISplitViewController else { return }
                    svc.preferredDisplayMode = .oneBesideSecondary
                    svc.preferredSplitBehavior = .tile
                }
            }
            
            func makeUIViewController(context: Self.Context) -> UIViewController {
                return ViewController()
            }
            
            func updateUIViewController(_ uiViewController: UIViewController, context: Self.Context) {
            }
        }
        
        func body(content: Content) -> some View {
            content.overlay (
                ControllerView().frame(width: 0, height: 0)
            )
        }
    }
    
    public func _body(configuration: _NavigationViewStyleConfiguration) -> some View {
        NavigationView {
            configuration.content
        }
        .modifier(ControllerModifier())
    }
    
    public init() {
    }
}