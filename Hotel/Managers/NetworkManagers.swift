//
//  NetworkManagers.swift
//  Hotel
//
//  Created by Новгородцев Никита on 31.08.2023.
//

import Foundation

final class NetworkManager {
    private var networkService = NetworkService.shared
    static let shared = NetworkManager()
    
    private init() {}
    
    //MARK: - fetchHotel
    func fetchHotel(completion: @escaping (Result<HotelModel, Error>) -> Void) {
        guard let url = URL(string: "https://run.mocky.io/v3/35e0d18e-2521-4f1b-a575-f0fe366f66e3") else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        networkService.makeRequest(request: request, completion: completion)
    }
    
    //MARK: - fetchPhoto
    func fetchPhoto(urlsString: [String], completion: @escaping (Result<[Data], Error>) -> Void) {
        var requestArray = [URLRequest]()
        
        for item in urlsString {
            guard let url = URL(string: item) else { return }
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            
            requestArray.append(request)
        }
        networkService.makeRequestArrayData(request: requestArray, completion: completion)
    }
    
    //MARK: - fetchRoomArray
    func fetchRoomArray(completion: @escaping (Result<RoomArray, Error>) -> Void) {
        guard let url = URL(string: "https://run.mocky.io/v3/f9a38183-6f95-43aa-853a-9c83cbb05ecd") else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        networkService.makeRequest(request: request, completion: completion)
    }
    
    //MARK: - fetchRoomPhoto
    func fetchRoomPhoto(urlsString: [String], completion: @escaping (Result<[Data], Error>) -> Void) {
        var requestArray = [URLRequest]()
        
        for item in urlsString {
            guard let url = URL(string: item) else { return }
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            
            requestArray.append(request)
        }
        networkService.makeRequestArrayData(request: requestArray, completion: completion)
    }
    
    //MARK: - fetchBookingModel
    func fetchBookingModel(completion: @escaping (Result<BookingModel, Error>) -> Void) {
        guard let url = URL(string: "https://run.mocky.io/v3/e8868481-743f-4eb2-a0d7-2bc4012275c8") else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        networkService.makeRequest(request: request, completion: completion)
    }
    
}
