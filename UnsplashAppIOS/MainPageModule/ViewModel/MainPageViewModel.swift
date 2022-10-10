//
//  MainPageViewModel.swift
//  UnsplashAppIOS
//
//  Created by Артем Соловьев on 10.10.2022.
//

import UIKit

final class MainPageViewModel {
    var loadMoreStatus = false
    var photos = Dynamic([Photos]())
    var page = 0
    
    func getRandomPhotos() {
        if !loadMoreStatus {
            loadMoreStatus = true
            self.page += 1
            UserDefaults.standard.set(page, forKey: "page")
            ApiManager.shared.getRandomPhotos { photos in
                self.photos.value = photos
                self.loadMoreStatus = false
            }
        }
    }
}
