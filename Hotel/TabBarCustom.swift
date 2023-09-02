//
//  TabBarCustom.swift
//  Hotel
//
//  Created by Новгородцев Никита on 01.09.2023.
//

import UIKit

final class TabBarController: UITabBarController {
    
    var coordinator: MainCoordinatorProtocol!
    
    //MARK: - mainView
    private let mainView: UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    //MARK: - button
    private lazy var button: UIButton = {
        var but = UIButton(type: .system)
        but.backgroundColor = .blue
        but.translatesAutoresizingMaskIntoConstraints = false
        but.layer.cornerRadius = 10
        but.setTitleColor(.white, for: .normal)
        but.setTitle("К выбору номера", for: .normal)
        but.addTarget(self, action: #selector(showController(sender:)), for: .touchUpInside)
        
        return but
    }()
    
    //MARK: - viewDidLoad
//    override func viewDidLoad() {
//        super .viewDidLoad()
//        setContraints()
//    }
    
    override func viewDidAppear(_ animated: Bool) {
        super .viewDidAppear(animated)
        setContraints()
    }
    
    //MARK: - setContraints
    private func setContraints() {
        self.tabBar.addSubview(mainView)
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: self.tabBar.topAnchor),
            mainView.leadingAnchor.constraint(equalTo: self.tabBar.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: self.tabBar.trailingAnchor),
            mainView.bottomAnchor.constraint(equalTo: self.tabBar.bottomAnchor)
        ])
        
        mainView.addSubview(button)
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 12),
            button.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 16),
            button.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -16),
            button.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    //MARK: - showController
    @objc private func showController(sender: UIButton) {
        coordinator.showHotelNumber()
    }
}
