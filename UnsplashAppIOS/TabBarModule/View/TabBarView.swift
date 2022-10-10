//
//  TabBarView.swift
//  UnsplashAppIOS
//
//  Created by Артем Соловьев on 10.10.2022.
//

import UIKit

final class TabBarView: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        createTabBar()
    }
    
    private func createTabBar() {
        let mainPage = MainPageView()
        let favouritePage = FavouriteView()
        
        let mainVC = UINavigationController(rootViewController: mainPage)
        let favouriteVC = UINavigationController(rootViewController: favouritePage)
        
        mainVC.title = "Главная страница"
        favouriteVC.title = "Избранное"
        
        mainVC.tabBarItem.image = UIImage(systemName: "photo")
        mainVC.tabBarItem.selectedImage = UIImage(systemName: "photo.fill")
        favouriteVC.tabBarItem.image = UIImage(systemName: "suit.heart")
        favouriteVC.tabBarItem.selectedImage = UIImage(systemName: "suit.heart.fill")
        
        tabBar.tintColor = .systemIndigo
        tabBar.unselectedItemTintColor = .black
        
        let viewControllers = [
            mainVC,
            favouriteVC
        ]
        
        tabBar.backgroundColor = .white
        
        self.setViewControllers(viewControllers, animated: true)
    }
}

