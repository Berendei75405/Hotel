//
//  HotelModel.swift
//  Hotel
//
//  Created by Новгородцев Никита on 31.08.2023.
//

import Foundation

// MARK: - HotelModel
struct HotelModel: Codable {
    let id: Int
    let name, adress: String
    let minimalPrice: Int
    let priceForIt: String
    let rating: Int
    let ratingName: String
    let imageUrls: [String]
    let aboutTheHotel: AboutTheHotel

    enum CodingKeys: String, CodingKey {
        case id, name, adress
        case minimalPrice = "minimal_price"
        case priceForIt = "price_for_it"
        case rating
        case ratingName = "rating_name"
        case imageUrls = "image_urls"
        case aboutTheHotel = "about_the_hotel"
    }
}

// MARK: - AboutTheHotel
struct AboutTheHotel: Codable {
    let description: String
    let peculiarities: [String]
}

