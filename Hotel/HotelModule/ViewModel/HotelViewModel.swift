//
//  HotelViewModel.swift
//  Hotel
//
//  Created by Новгородцев Никита on 31.08.2023.
//

import Foundation
import Combine

//MARK: - TableState
enum TableState {
    case success, failure, initial
}

protocol HotelViewModelProtocol: AnyObject {
    var hotel: HotelModel? {get set}
    var imagesData: [Data] {get set}
    var updateTableState: PassthroughSubject<TableState, Never> {get set}
    func fetchHotel()
}

final class HotelViewModel: HotelViewModelProtocol {
    var coordinator: MainCoordinatorProtocol!
    private let networkManager = NetworkManager.shared
    
    var hotel: HotelModel?
    var imagesData: [Data] = []
    var updateTableState = PassthroughSubject<TableState, Never>()
    
    //MARK: - fetchHotel
    func fetchHotel() {
        networkManager.fetchHotel { [weak self] result in
            switch result {
            case .success(let hotel):
                self?.hotel = hotel
                self?.fetchPhoto()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    //MARK: - fetchPhoto
    private func fetchPhoto() {
        guard let hotel = hotel else { return }
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            self?.networkManager.fetchPhoto(urlsString: hotel.imageUrls) { [weak self] result in
                switch result {
                case .success(let photos):
                    if photos.isEmpty {
                        self?.updateTableState.send(.failure)
                    } else {
                        self?.imagesData = photos
                        self?.updateTableState.send(.success)
                    }
                case .failure(_):
                    self?.updateTableState.send(.failure)
                }
            }
        }
    }
    
    deinit {
        print("HotelViewModel")
    }
}
