//
//  BaseTabBarController.swift
//  AppStoreAPI
//
//  Created by Nikita Gundorin on 28.06.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import UIKit

class BaseTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewControllers()
    }
    
    private func setupViewControllers() {
        viewControllers = [
            createNavController(viewController: AppsPageViewController(), title: "Apps", imageName: "apps"),
            createNavController(viewController: UIViewController(), title: "Today", imageName: "today"),
            createNavController(viewController: AppsSearchViewController(), title: "Search", imageName: "search"),
        ]
    }
    
    private func createNavController(viewController: UIViewController, title: String, imageName: String) -> UIViewController {
        viewController.navigationItem.title = title
        if #available(iOS 13, *) {
            viewController.view.backgroundColor = .systemBackground
        } else {
            viewController.view.backgroundColor = .white
        }
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = UIImage(named: imageName)
        navController.navigationBar.prefersLargeTitles = true
        
        return navController
    }
}
