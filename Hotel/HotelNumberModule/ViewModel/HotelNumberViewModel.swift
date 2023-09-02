//
//  HotelNumberViewModel.swift
//  Hotel
//
//  Created by Новгородцев Никита on 01.09.2023.
//

import Foundation
import Combine

protocol HotelNumberViewModelProtocol: AnyObject {
    var roomArray: RoomArray? { get set }
    var imagesArray: [[Data]] { get set }
    var updateTableState: PassthroughSubject<TableState, Never> {get set}
    func popToRoot()
    func fetchRoomArray()
    func showBooking()
}

final class HotelNumberViewModel: HotelNumberViewModelProtocol {
    var coordinator: MainCoordinatorProtocol!
    let networkManager = NetworkManager.shared
    
    var roomArray: RoomArray?
    var imagesArray: [[Data]] = []
    var updateTableState = PassthroughSubject<TableState, Never>()
    
    //MARK: - popToRoot
    func popToRoot() {
        coordinator.popToRoot()
    }
    
    //MARK: - fetchRoomArray
    func fetchRoomArray() {
        networkManager.fetchRoomArray { [weak self] result in
            switch result {
            case .success(let room):
                self?.roomArray = room
                self?.fetchPhoto()
            case .failure(let error):
                print(error)
                self?.updateTableState.send(.failure)
            }
        }
    }
    
    //MARK: - fetchPhoto
    private func fetchPhoto() {
        guard let roomNotOptional = roomArray?.rooms else { return }
        DispatchQueue.global(qos: .userInteractive).async { [unowned self] in
            for i in roomNotOptional {
                networkManager.fetchRoomPhoto(urlsString: i.imageUrls) { [weak self] result in
                    switch result {
                    case .success(let photo):
                        if photo.isEmpty {
                            self?.updateTableState.send(.failure)
                        } else {
                            self?.imagesArray.append(photo)
                        }
                        if roomNotOptional.count == self?.imagesArray.count {
                            self?.updateTableState.send(.success)
                        }
                    case .failure(_):
                        self?.updateTableState.send(.failure)
                    }
                }
            }
        }
    }
    
    //MARK: - showBooking
    func showBooking() {
        coordinator.showBookingModule() 
    }
    
    deinit {
        print("HotelNumberViewModel")
    }
}
