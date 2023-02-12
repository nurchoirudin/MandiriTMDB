//
//  AppDelegate.swift
//  Mandiri TMDB Test
//
//  Created by SehatQ on 08/02/23.
//

import UIKit

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        app.router.launchMainView()
        
        return true
    }

}

