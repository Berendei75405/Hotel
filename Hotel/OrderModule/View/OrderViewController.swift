//
//  OrderViewController.swift
//  Hotel
//
//  Created by Новгородцев Никита on 04.09.2023.
//

import UIKit

final class OrderViewController: UIViewController {
    
    var viewModel: OrderViewModelProtocol!
    
    //MARK: - titleLabel
    private let titleLabel: UILabel = {
        let lab = UILabel()
        lab.font = UIFont(name: "SFProDisplay-Medium", size: 22)
        lab.translatesAutoresizingMaskIntoConstraints = false
        lab.textColor = .black
        lab.lineBreakMode = .byWordWrapping
        lab.textAlignment = .center
        lab.numberOfLines = 0
        lab.text = "Ваш заказ принят в работу"
        
        return lab
    }()
    
    //MARK: - descriptionLabel
    private let descriptionLabel: UILabel = {
        let lab = UILabel()
        lab.font = UIFont(name: "SFProDisplay-Regular", size: 16)
        lab.translatesAutoresizingMaskIntoConstraints = false
        lab.textColor = UIColor(red: 0.51, green: 0.53, blue: 0.59, alpha: 1)
        lab.lineBreakMode = .byWordWrapping
        lab.textAlignment = .center
        lab.numberOfLines = 0
        lab.text = "Подтверждение заказа №\(Int.random(in: 1..<1000)) может занять некоторое время (от 1 часа до суток). Как только мы получим ответ от туроператора, вам на почту придет уведомление."
        
        return lab
    }()
    
    //MARK: - imageView
    private let imageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "Party")
        
        return image
    }()
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super .viewDidLoad()
        view.backgroundColor = .white
        setBackButton()
        setupConstraint()
    }
    
    //MARK: - setupConstraint
    private func setupConstraint() {
        //titleLabel constraints
        view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            titleLabel.widthAnchor.constraint(equalToConstant: view.frame.width - 32)
        ])
        
        //descriptionLabel constraints
        view.addSubview(descriptionLabel)
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 23),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -23)
        ])
        
        //imageView constraints
        view.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -32),
            imageView.heightAnchor.constraint(equalToConstant: 94),
            imageView.widthAnchor.constraint(equalToConstant: 94),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
}
