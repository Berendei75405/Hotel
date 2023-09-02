//
//  BookingViewModel.swift
//  Hotel
//
//  Created by Новгородцев Никита on 02.09.2023.
//

import Foundation
import Combine

protocol BookingViewModelProtocol: AnyObject {
    var bookingModel: BookingModel? { get set }
    var updateTableState: PassthroughSubject<TableState, Never> {get set}
    func fetchBookingModel()
    func popToRoot()
}

final class BookingViewModel: BookingViewModelProtocol {
    var coordinator: MainCoordinatorProtocol!
    private let networkManager = NetworkManager.shared
    
    deinit {
        print("BookingViewModel")
    }
    
    var bookingModel: BookingModel?
    var updateTableState = PassthroughSubject<TableState, Never>()
    
    //MARK: - fetchBookingModel
    func fetchBookingModel() {
        networkManager.fetchBookingModel { [weak self] result in
            switch result {
            case .success(let model):
                self?.bookingModel = model
                self?.updateTableState.send(.success)
            case .failure(let error):
                print(error)
                self?.updateTableState.send(.failure)
            }
        }
    }
    
    //MARK: - popToRoot()
    func popToRoot() {
        coordinator.goBack()
    }
}

