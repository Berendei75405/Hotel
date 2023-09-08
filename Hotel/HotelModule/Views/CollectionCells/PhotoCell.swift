//
//  PhotoCell.swift
//  Hotel
//
//  Created by Новгородцев Никита on 31.08.2023.
//

import UIKit

//MARK: - PhotoCell
final class PhotoCell: UICollectionViewCell {
    static let identifier = "PhotoCell"
    
    //MARK: - hotelImageView
    private let hotelImageView: UIImageView = {
        let image = UIImageView()
        image.frame.size.height = 257
        image.layer.cornerRadius = 20
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleToFill
        image.clipsToBounds = true
        image.tintColor = .gray
        image.backgroundColor = .white
        
        return image
    }()
    
    //MARK: - stackView
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 10
        stack.layoutMargins = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layer.cornerRadius = 5
        stack.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        stack.alignment = .center
        stack.distribution = .fill
        
        return stack
    }()
    
    private var countPhoto = 0
    
    //MARK: - override init
    override init(frame: CGRect) {
        super .init(frame: frame)
        setupConstraint()
        createStackView()
    }
    
    //MARK: - setupConstraint
    private func setupConstraint() {
        //hotelImageView
        contentView.addSubview(hotelImageView)
        NSLayoutConstraint.activate([
            hotelImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            hotelImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            hotelImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            hotelImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    private func createStackView() {
        //stackView constraints
        hotelImageView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            stackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 17)
        ])
        
        for i in 0..<countPhoto {
            let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.widthAnchor.constraint(equalToConstant: 7).isActive = true
            button.layer.cornerRadius = 3.5
            guard let index = Int(contentView.accessibilityIdentifier ?? "") else { return }
            if index == i {
                button.backgroundColor = .black
            } else {
                button.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.22)
            }
            stackView.addArrangedSubview(button)
        }
    }
    
    //MARK: - configurate
    func configurate(image: UIImage, countPhoto: Int) {
        self.hotelImageView.image = image
        if countPhoto > 0 && self.countPhoto == 0 {
            self.countPhoto = countPhoto
            createStackView()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
