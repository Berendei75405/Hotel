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
    
    //MARK: - override init
    override init(frame: CGRect) {
        super .init(frame: frame)
        
        setupConstraint()
        
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
    
    //MARK: - configurate
    func configurate(image: UIImage) {
        self.hotelImageView.image = image
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
