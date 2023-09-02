//
//  TabBarController.swift
//  Hotel
//
//  Created by Новгородцев Никита on 01.09.2023.
//

import UIKit

final class TabBarController: UITabBarController {
    var coordinator: MainCoordinatorProtocol!
    
    weak var hotelView: HotelViewController?
    weak var hotelNumberView: HotelNumberViewController?
    
    //MARK: - button
    let button: UIButton = {
        var but = UIButton(type: .system)
        but.translatesAutoresizingMaskIntoConstraints = false
        but.backgroundColor = #colorLiteral(red: 0.2, green: 0.4392156863, blue: 0.9647058824, alpha: 1)
        but.layer.cornerRadius = 10
        but.setTitle("К выбору номера", for: .normal)
        but.titleLabel?.font = .init(name: "SFProDisplay-Medium", size: 16)
        but.setTitleColor(.white, for: .normal)
        
        return but
    }()
    
    //MARK: - viewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        super .viewDidAppear(animated)
        setupConstraints()
        button.addTarget(self, action: #selector(buttonAction(sender:)), for: .touchUpInside)
    }
    
    //MARK: - setupConstraints
    private func setupConstraints() {
        self.tabBar.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: self.tabBar.topAnchor, constant: 12),
            button.leadingAnchor.constraint(equalTo: self.tabBar.leadingAnchor, constant: 16),
            button.trailingAnchor.constraint(equalTo: self.tabBar.trailingAnchor, constant: -16),
            button.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    //MARK: - buttonAction
    @objc private func buttonAction(sender: UIButton) {
        coordinator.showHotelNumber(title: hotelView?.viewModel.hotel?.name ?? "")
    }
    
}
