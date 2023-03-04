//
//  AppCoordinator.swift
//  BreadDiary
//
//  Created by Michel Goñi on 26/2/23.
//

import NumbersUI
import SwiftUI

protocol AppCoordinatorType {

    func start(with window: UIWindow)
}

final class AppCoordinator: AppCoordinatorType {
    private var window: UIWindow?
    private lazy var viewFactory: ViewFactory = { ViewFactory() }()

    func start(with window: UIWindow) {
        debugPrint("Starting app coordinator")
        self.window = window
        self.window?.makeKeyAndVisible()
        setRoot()
    }
}

private extension AppCoordinator {
    func setRoot() {
        debugPrint("Setting TabBar as Root")
        self.window?.rootViewController = viewFactory.getMainView().eraseToHostingController()
    }
}

 extension View {

     func eraseToHostingController() -> UIHostingController<Self> { .init(rootView: self) }
}
