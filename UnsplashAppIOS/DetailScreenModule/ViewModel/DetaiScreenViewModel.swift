//
//  DetaiScreenViewModel.swift
//  UnsplashAppIOS
//
//  Created by Артем Соловьев on 11.10.2022.
//

import Foundation

class DetaiScreenViewModel {
    var download = Dynamic(0.0)
    
    func getDetail() {
        ApiManager.shared.getDetailPhotos { photo in
            self.download.value = photo.downloads ?? 0
        }
    }
}
