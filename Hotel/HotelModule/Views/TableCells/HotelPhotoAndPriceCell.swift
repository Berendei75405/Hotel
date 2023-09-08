//
//  HotelPhotoCell.swift
//  Hotel
//
//  Created by Новгородцев Никита on 31.08.2023.
//

import UIKit

protocol HotelPhotoAndPriceCellDataSource: AnyObject {
    func photoCount() -> Int
    func fetchPhoto(index: Int) -> UIImage
}

final class HotelPhotoAndPriceCell: UITableViewCell {
    static let identifier = "HotelPhotoAndPriceCell"
    
    //MARK: - mainView
    private let mainView: UIView = {
        var view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 20
        
        return view
    }()
    
    //MARK: - collectionView
    private lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: contentView.bounds, collectionViewLayout: createLayout())
        
        collection.backgroundColor = .white
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        collection.decelerationRate = .fast
        
        //регистрация яйчеек
        collection.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.identifier)
        
        collection.dataSource = self
        collection.delegate = self
        
        contentView.addSubview(collection)
        
        return collection
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
    
    //MARK: - priceLabel
    private let priceLabel: UILabel = {
        let lab = UILabel()
        lab.font = UIFont(name: "SFProDisplay-Semibold", size: 30)
        lab.translatesAutoresizingMaskIntoConstraints = false
        lab.textColor = .black
        
        return lab
    }()
    
    //MARK: - priceForItLabel
    private let priceForItLabel: UILabel = {
        let lab = UILabel()
        lab.font = UIFont(name: "SFProDisplay-Regular", size: 16)
        lab.textColor = #colorLiteral(red: 0.5811160207, green: 0.6012901664, blue: 0.6538151503, alpha: 1)
        lab.translatesAutoresizingMaskIntoConstraints = false
        lab.textColor = .black
        
        return lab
    }()
    
    private var photoCount = 0
    
    weak var dataSource: HotelPhotoAndPriceCellDataSource?
    
    //MARK: - init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        
        //collectionView constraints
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: mainView.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 257)
        ])

        //markStackView constraints
        NSLayoutConstraint.activate([
            markStackView.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 16),
            markStackView.leadingAnchor.constraint(equalTo: collectionView.leadingAnchor, constant: 16),
            markLabel.heightAnchor.constraint(equalToConstant: 29)
        ])

        //titleLabel constraints
        mainView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: markStackView.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: collectionView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor, constant: -16)
        ])

        //addressButton constraints
        mainView.addSubview(addressButton)
        NSLayoutConstraint.activate([
            addressButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            addressButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            addressButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])

        //priceLabel constraints
        mainView.addSubview(priceLabel)
        NSLayoutConstraint.activate([
            priceLabel.topAnchor.constraint(equalTo: addressButton.bottomAnchor, constant: 16),
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
        ])

        //priceForItLabel constraints
        mainView.addSubview(priceForItLabel)
        NSLayoutConstraint.activate([
            priceForItLabel.bottomAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: -3),
            priceForItLabel.leadingAnchor.constraint(equalTo: priceLabel.trailingAnchor, constant: 8)
        ])
    }
    
    //MARK: - createLayout
    private func createLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { index, _ in
            switch index {
            case .zero:
                let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(self.contentView.frame.width), heightDimension: .absolute(257))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = .init(top: 0, leading: 10, bottom: 0, trailing: 10)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(200), heightDimension: .absolute(257))
                
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .paging
    
                return section
            default:
                return NSCollectionLayoutSection(group: NSCollectionLayoutGroup(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(.zero), heightDimension: .absolute(.zero))))
            }
        }
    }
    
    //MARK: - configurate
    func confugurate(rating: Int, ratingName: String,
                     title: String, address: String,
                     price: Int, priceForIt: String, countPhoto: Int) {
        self.markLabel.text = "\(rating) \(ratingName)"
        self.titleLabel.text = title
        self.addressButton.setTitle(address, for: .normal)
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        guard let newPrice = numberFormatter.string(from: NSNumber(value: price)) else { return }

        self.priceLabel.text = "От \(newPrice.replacingOccurrences(of: ",", with: " "))₽"
        self.priceForItLabel.text = priceForIt
        self.photoCount = countPhoto
    }
}

//MARK: - HotelPhotoAndPriceCell
extension HotelPhotoAndPriceCell: UICollectionViewDelegate,
                                  UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?.photoCount() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.identifier, for: indexPath) as? PhotoCell else { return UICollectionViewCell() }
        
        cell.contentView.accessibilityIdentifier = String(indexPath.row)
        cell.configurate(image: dataSource?.fetchPhoto(index: indexPath.row) ?? UIImage(), countPhoto: photoCount)
        
        return cell
    }
}
