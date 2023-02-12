//
//  AppRouter.swift
//  Mandiri TMDB Test
//
//  Created by SehatQ on 11/02/23.
//

import UIKit

final class AppRouter {
    let window: UIWindow
    
    init() {
        window = UIWindow(frame: UIScreen.main.bounds)
    }
    
    func launchMainView(){
        let viewController = MainViewRouter.createMainViewModule()
        let navigationController = UINavigationController(rootViewController: viewController)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }

}
