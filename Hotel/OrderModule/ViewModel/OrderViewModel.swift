//
//  OrderViewModel.swift
//  Hotel
//
//  Created by Новгородцев Никита on 04.09.2023.
//

import Foundation

protocol OrderViewModelProtocol: AnyObject {
    func popToRoot()
}

final class OrderViewModel: OrderViewModelProtocol {
    var coordinator: MainCoordinatorProtocol!
    
    //MARK: - popToRoot
    func popToRoot() {
        coordinator.popToRoot()
    }
}
