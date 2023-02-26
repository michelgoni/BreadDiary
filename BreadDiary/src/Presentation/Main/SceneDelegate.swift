//
//  SceneDelegate.swift
//  BreadDiary
//
//  Created by Michel Goñi on 26/2/23.
//

import Foundation
import SwiftUI

class SceneDelegate: NSObject, UIWindowSceneDelegate {

    var window: UIWindow?
    private let coordinator = AppCoordinator()

    func scene(_ scene: UIScene, willConnectTo
               session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        coordinator.start(with: UIWindow(windowScene: scene))
        print("SceneDelegate is connected!")
    }
}
