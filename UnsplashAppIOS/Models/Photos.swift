//
//  Photos.swift
//  UnsplashAppIOS
//
//  Created by Артем Соловьев on 10.10.2022.
//

import Foundation

class Photos: Codable {
    var urls: Image?
    var user: User?
    var downloads: Int?
    var created_at: String?
}

class Image: Codable {
    var full: String?
    var small: String?
}

class User: Codable {
    var username: String?
    var location: String?
}
