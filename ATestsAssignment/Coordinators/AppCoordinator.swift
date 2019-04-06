//
//  AppCoordinator.swift
//  ATestsAssignment
//
//  Created by Vitalii Shkliar on 4/6/19.
//  Copyright © 2019 Vitalii Shkliar. All rights reserved.
//

import UIKit

class AppCoordinator: Coordinator {
     let window: UIWindow?
    
    
    init(window: UIWindow?) {
        self.window = window
    }
    
    var rootViewController: UINavigationController!
    
    override func start() {
        guard let window = window else {
            fatalError("Window is missing")
        }
        let homeVCViewModel = HomeViewControllerViewModel(coordinatorDelegate: self)
        let homeVC = HomeViewController.create(with: homeVCViewModel)
        rootViewController = UINavigationController(rootViewController: homeVC)
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
    }
    
    //Cannot finish as it is the root coordinator
    override func finish() {}
    
}

extension AppCoordinator {
    func goToUserDetails(with userModel: UserModel) {
        let vm = UserDetailsVCViewModel(with: userModel)
        let vc = UserDetailsViewController.create(with: vm)
        rootViewController.pushViewController(vc, animated: true)
    }
}

extension AppCoordinator: HomeViewControllerViewModelCoordinatorDelegate {
    func didSelect(user: UserModel) {
        goToUserDetails(with: user)
    }
}
