//
//  SceneDelegate.swift
//  UnsplashAppIOS
//
//  Created by Артем Соловьев on 10.10.2022.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        setupWindow(scene: scene)
        
        let favData = UserDefaults.standard.data(forKey: "favPhotos")
        guard let favData = favData else { return }
        let favArray = try! JSONDecoder().decode([Photos].self, from: favData)
        
        if favArray.isEmpty {
            let photosArray: [Photos] = []
            let photosArrayData = try! JSONEncoder().encode(photosArray)
            UserDefaults.standard.set(photosArrayData, forKey: "favPhotos")
            NotificationCenter.default.post(name: NSNotification.Name("favPhotos"), object: nil)
        } else {
            NotificationCenter.default.post(name: NSNotification.Name("favPhotos"), object: nil)
        }
    }
    
    private func setupWindow(scene: UIScene) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        let controller = TabBarView()
        window?.rootViewController = controller
        window?.overrideUserInterfaceStyle = .light
        window?.makeKeyAndVisible()
    }
}

