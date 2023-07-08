//
//  CustomButton.swift
//  MyHabits
//
//  Created by Sokolov on 02.07.2023.
//

import UIKit

class CustomButton {
    
    func createBarButtom(imageName: String, selector: Selector) -> UIBarButtonItem {
        
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: imageName), for: .normal)
        button.addTarget(self, action: selector, for: .touchUpInside)
        button.tintColor = UIColor(red: 0.63, green: 0.09, blue: 0.80, alpha: 1.00)
        
        let menuBarItem = UIBarButtonItem(customView: button)
        
        return menuBarItem
    }
}
