//
//  Coordinator.swift
//  Hotel
//
//  Created by Новгородцев Никита on 31.08.2023.
//

import UIKit

protocol MainCoordinatorProtocol: AnyObject {
    func initialViewController()
    func createModule() -> UIViewController
    func createHotelNumberModule() -> UIViewController
    func showHotelNumber(title: String)
    func popToRoot()
    func createBookingModule() -> UIViewController
    func showBookingModule()
    func goBack()
    func createOrderModule() -> UIViewController
    func showOrderModule() 
}

final class Coordinator: MainCoordinatorProtocol {
    private var tabBarCon: TabBarController?
    
    //MARK: - init
    init(tabBarCon: TabBarController) {
        self.tabBarCon = tabBarCon
    }
    
    //MARK: - initialViewController
    func initialViewController() {
        if let tabBarCon = tabBarCon {
            let view = createModule()
            
            tabBarCon.viewControllers = [UINavigationController(rootViewController: view)]
        }
    }
    
    //MARK: - createModule
    func createModule() -> UIViewController {
        let view = HotelViewController()
        let viewModel = HotelViewModel()
        let coordinator = self
        
        view.viewModel = viewModel
        viewModel.coordinator = coordinator
        tabBarCon?.coordinator = coordinator
        tabBarCon?.hotelView = view
        
        return view
    }
    
    //MARK: - createHotelNumberModule
    func createHotelNumberModule() -> UIViewController {
        let view = HotelNumberViewController()
        let viewModel = HotelNumberViewModel()
        let coordinator = self

        view.viewModel = viewModel
        viewModel.coordinator = coordinator
        
        return view
    }
    
    //MARK: - showHotelNumber
    func showHotelNumber(title: String) {
        if let tabBarCon = tabBarCon {
            let view = createHotelNumberModule()
            guard let viewHotelNumber = view as? HotelNumberViewController else { return }
            viewHotelNumber.select = title
            tabBarCon.tabBar.isHidden = true
  
            guard let nvc = tabBarCon.viewControllers?.first as? UINavigationController else {return}
            view.navigationItem.title = title
            view.navigationItem.hidesBackButton = true
            nvc.pushViewController(view, animated: true)
        }
    }
    
    //MARK: - popToRoot
    func popToRoot() {
        if let tabBarCon = tabBarCon {
            tabBarCon.tabBar.isHidden = false
            guard let nvc = tabBarCon.viewControllers?.first as? UINavigationController else {return}
            
            let first = nvc.viewControllers.first
            nvc.viewControllers.removeAll()
            nvc.viewControllers = [first!]
        }
    }
    
    //MARK: - createBookingModule
    func createBookingModule() -> UIViewController {
        let view = BookingViewController()
        let viewModel = BookingViewModel()
        let coordinator = self
        if let tabBar = tabBarCon {
            view.tabBar = tabBar 
        }

        view.viewModel = viewModel
        viewModel.coordinator = coordinator
        
        return view
    }
    
    //MARK: - showBookingModule
    func showBookingModule() {
        if let tabBarCon = tabBarCon {
            let view = createBookingModule()
            guard let nvc = tabBarCon.viewControllers?.first as? UINavigationController else {return}
            view.navigationItem.title = "Бронирование"
            view.navigationItem.hidesBackButton = true
            tabBarCon.tabBar.isHidden = false
            
            nvc.pushViewController(view, animated: true)
        }
    }
    
    //MARK: - goBack
    func goBack() {
        if let tabBarCon = tabBarCon {
            guard let nvc = tabBarCon.viewControllers?.first as? UINavigationController else {return}
            
            nvc.popViewController(animated: true)
        }
    }
    
    //MARK: - createOrderModule
    func createOrderModule() -> UIViewController {
        let view = OrderViewController()
        let viewModel = OrderViewModel()
        let coordinator = self

        view.viewModel = viewModel
        viewModel.coordinator = coordinator
        
        return view
    }
    
    //MARK: - showOrderModule
    func showOrderModule() {
        if let tabBarCon = tabBarCon {
            let view = createOrderModule()
            guard let nvc = tabBarCon.viewControllers?.first as? UINavigationController else {return}
            view.navigationItem.hidesBackButton = true
            tabBarCon.tabBar.isHidden = false
            
            nvc.pushViewController(view, animated: true)
        }
    }
}
