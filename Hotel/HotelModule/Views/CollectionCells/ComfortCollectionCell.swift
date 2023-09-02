//
//  ComfortCollectionCell.swift
//  Hotel
//
//  Created by Новгородцев Никита on 31.08.2023.
//

import UIKit

final class ComfortCollectionCell: UICollectionViewCell {
    static let identifier = "ComfortCollectionCell"
    
    //MARK: - titleLabel
    private let titleLabel: UILabel = {
        let lab = UILabel()
        lab.font = UIFont(name: "SFProDisplay-Medium", size: 16)
        lab.translatesAutoresizingMaskIntoConstraints = false
        lab.textColor = #colorLiteral(red: 0.5811160207, green: 0.6012901664, blue: 0.6538151503, alpha: 1)
        lab.textAlignment = .center
        
        return lab
    }()
    
    //MARK: - init
    override init(frame: CGRect) {
        super .init(frame: frame)
        backgroundColor = #colorLiteral(red: 0.9843137255, green: 0.9843137255, blue: 0.9882352941, alpha: 1)
        
        contentView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
        ])
    }
    
    //MARK: - configurate
    func configurate(title: String) {
        self.titleLabel.text = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
