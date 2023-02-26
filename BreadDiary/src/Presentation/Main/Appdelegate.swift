//
//  Appdelegate.swift
//  BreadDiary
//
//  Created by Michel Goñi on 26/2/23.
//

import Foundation
import SwiftUI

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication,
                     configurationForConnecting
                     connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        let sceneConfig: UISceneConfiguration = UISceneConfiguration(name: nil,
                                                                     sessionRole: connectingSceneSession.role)

        sceneConfig.delegateClass = SceneDelegate.self
        return sceneConfig
    }
}
