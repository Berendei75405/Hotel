//
//  HotelTableCell.swift
//  Hotel
//
//  Created by Новгородцев Никита on 02.09.2023.
//

import UIKit

final class HotelTableCell: UITableViewCell {
    static let identifier = "HotelPhotoAndPriceCell"
    
    //MARK: - mainView
    private let mainView: UIView = {
        var view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 20
        
        return view
    }()
    
    //MARK: - starImageView
    private let starImageView: UIImageView = {
        var img = UIImageView(image: UIImage(systemName: "star.fill"))
        img.translatesAutoresizingMaskIntoConstraints = false
        img.contentMode = .scaleAspectFit
        img.tintColor = UIColor(red: 1, green: 0.66, blue: 0, alpha: 1)
        
        return img
    }()
    
    //MARK: - markLabel
    private let markLabel: UILabel = {
        var lab = UILabel()
        lab.font = .init(name: "SFProDisplay-Medium", size: 16)
        lab.textColor = UIColor(red: 1, green: 0.66, blue: 0, alpha: 1)
        
        return lab
    }()
    
    //MARK: - markStackView
    private lazy var markStackView: UIStackView = {
        var stackView = UIStackView(arrangedSubviews: [starImageView, markLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.layer.cornerRadius = 5
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = .init(top: 5, left: 16, bottom: 5, right: 16)
        stackView.backgroundColor = #colorLiteral(red: 0.9943507314, green: 0.9627688527, blue: 0.8500519395, alpha: 1)
        mainView.addSubview(stackView)
        
        return stackView
    }()
    
    //MARK: - titleLabel
    private let titleLabel: UILabel = {
        let lab = UILabel()
        lab.font = UIFont(name: "SFProDisplay-Medium", size: 22)
        lab.translatesAutoresizingMaskIntoConstraints = false
        lab.textColor = .black
        lab.lineBreakMode = .byWordWrapping
        lab.numberOfLines = 0
        
        return lab
    }()
    
    //MARK: - addressButton
    private let addressButton: UIButton = {
        var but = UIButton(type: .system)
        but.setTitleColor(.blue, for: .normal)
        but.translatesAutoresizingMaskIntoConstraints = false
        but.backgroundColor = .white
        but.titleLabel?.font = .init(name: "SFProDisplay-Medium", size: 14)
        but.contentHorizontalAlignment = .left
        
        return but
    }()
    
    
    //MARK: - init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - configurate
    func configurate(rating: Int, ratingName: String,
                     title: String, address: String) {
        self.markLabel.text = "\(rating) \(ratingName)"
        self.titleLabel.text = title
        self.addressButton.setTitle(address, for: .normal)
    }
    
    //MARK: - setupConstraints
    private func setupConstraints() {
        //mainView constraint
        contentView.addSubview(mainView)
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            mainView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
        contentView.backgroundColor = #colorLiteral(red: 0.9647058824, green: 0.9647058824, blue: 0.9764705882, alpha: 1)
        
        //markStackView constraints
        NSLayoutConstraint.activate([
            markStackView.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 16),
            markStackView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 16),
            markLabel.heightAnchor.constraint(equalToConstant: 29)
        ])

        //titleLabel constraints
        mainView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: markStackView.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -16)
        ])

        //addressButton constraints
        mainView.addSubview(addressButton)
        NSLayoutConstraint.activate([
            addressButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            addressButton.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 16),
            addressButton.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -16)
        ])
    }
}
