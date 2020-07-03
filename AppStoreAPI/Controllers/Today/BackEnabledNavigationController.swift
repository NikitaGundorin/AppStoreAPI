//
//  BackEnabledNavigationController.swift
//  AppStoreAPI
//
//  Created by Nikita Gundorin on 03.07.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import UIKit

class BackEnabledNavigationController: UINavigationController, UIGestureRecognizerDelegate {
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.interactivePopGestureRecognizer?.delegate = self
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return self.viewControllers.count > 1
    }
}
