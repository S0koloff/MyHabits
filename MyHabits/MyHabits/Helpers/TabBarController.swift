//
//  TabBarController.swift
//  MyHabits
//
//  Created by Sokolov on 02.07.2023.
//

import UIKit

final class TabBarController {
    
    func createTabBarController() -> UITabBarController {
        
        let mainVC = UINavigationController(rootViewController: MainViewController(habitsDataManager: HabitsDataManager()))
        let infoVC = UINavigationController(rootViewController: InfoViewController())
        
        let tabBarController = UITabBarController()
        
        tabBarController.tabBar.tintColor = Colors.purple
        tabBarController.tabBar.unselectedItemTintColor = .systemGray2
        tabBarController.tabBar.backgroundColor = .white
        
        tabBarController.viewControllers = [mainVC, infoVC]
        tabBarController.viewControllers?.enumerated().forEach {
            $1.tabBarItem.title = $0 == 0 ? "Привычки" : "Информация"
            $1.tabBarItem.image = $0 == 0 ? UIImage(systemName: "rectangle.grid.1x2.fill")
                                          : UIImage(systemName: "info.circle.fill")
        }
        
        return tabBarController
    }
}
