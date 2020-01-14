//
//  AppDelegate.swift
//  RxTodo-app
//
//  Created by Çağrı ÇOLAK on 10.01.2020.
//  Copyright © 2020 MW. All rights reserved.
//

import UIKit
import RxAlertViewable

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var todoListCoordinator:TodoListCoordinator?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        configureRxAlert()
        let navController = UINavigationController()
        todoListCoordinator = TodoListCoordinator(navigationController: navController)
        todoListCoordinator?.navigateTo()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
        return true
    }
    
    private func configureRxAlert() {
        RxAlert.config = RxAlertConfig(tip: "Todo",
                                       confirm: "Comfirm",
                                       warning: "Warning",
                                       error: "Error",
                                       yes: "Yes",
                                       no: "Cancel",
                                       ok: "Done",
                                       tintColor: .red)
    }

}

