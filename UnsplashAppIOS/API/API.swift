//
//  API.swift
//  UnsplashAppIOS
//
//  Created by Артем Соловьев on 10.10.2022.
//

import Alamofire

var baseUrl: String {
    return "https://api.unsplash.com/"
}

var page: Int {
    return UserDefaults.standard.integer(forKey: "page")
}

var randomPhotos: String {
    return "photos?page=\(page)"
}

class ApiManager {
    static let shared = ApiManager()
    
    func getRandomPhotos(completion: @escaping ([Photos]) -> Void) {
        NotificationCenter.default.addObserver(forName: NSNotification.Name("page"), object: nil, queue: .main) { (_) in
        }
        
        let headers: HTTPHeaders = [
            "Authorization":"Client-ID ULDHWyQujObtctLYQCkmX8CwyMesRtsZ8UUT5vrkIKw"
        ]
        
        AF.request(baseUrl + randomPhotos, method: .get, headers: headers).response { responseData in
            guard let data = responseData.data else { return }
            if let photos = try? JSONDecoder().decode([Photos].self, from: data) {
                completion(photos)
            } else {
                print("Parse Error")
            }
        }
    }
}
