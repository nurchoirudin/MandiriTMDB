//
//  UIViewController+Extension.swift
//  Mandiri TMDB Test
//
//  Created by SehatQ on 11/02/23.
//

import UIKit

extension UIViewController {
    func setupNavigationWithLeftTitle(title: String, rightButton: Bool = false) {
        if #available(iOS 15, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor(hexString: "#081c24")
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
            appearance.shadowColor = .clear
            appearance.shadowImage = UIImage()
            self.navigationController?.navigationBar.standardAppearance = appearance
            self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        }
        navigationController?.navigationBar.setBackgroundImage(nil, for:.default)
        navigationController?.navigationBar.shadowImage = nil
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.layoutIfNeeded()
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.barTintColor = UIColor(hexString: "#081c24")
    }
 
    static func loadFromNib() -> Self {
        func instantiateFromNib<T: UIViewController>() -> T {
            return T.init(nibName: String(describing: T.self), bundle: nil)
        }
        
        return instantiateFromNib()
    }
    
    func showError(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)

    }
}
