//
//  RoomTableCell.swift
//  Hotel
//
//  Created by Новгородцев Никита on 01.09.2023.
//

import UIKit

protocol RoomTableCellDataSourceProtocol: AnyObject {
    func countPhoto(indexTableRows: Int) -> Int
    func fetchPhoto(index: Int, indexTableRows: Int) -> UIImage
    func countPeculiarities(indexTableRows: Int) -> Int
    func fetchPeculiarities(index: Int, indexTableRows: Int) -> String
}

protocol RoomTableCellDelegateProtocol: AnyObject {
    func roomWasSelect(index: Int)
}

final class RoomTableCell: UITableViewCell {
    static let identifier = "RoomTableCell"
    weak var dataSource: RoomTableCellDataSourceProtocol?
    weak var delegate: RoomTableCellDelegateProtocol?
    var indexPath = IndexPath()

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
        let collection = UICollectionView(frame: contentView.bounds, collectionViewLayout: createLayoutPhotoCollection())
        
        collection.backgroundColor = .white
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        collection.decelerationRate = .fast
        collection.accessibilityIdentifier = "collectionView"
        
        //регистрация яйчеек
        collection.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.identifier)
        
        collection.dataSource = self
        collection.delegate = self
        
        contentView.addSubview(collection)
        
        return collection
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
    
    //MARK: - peculiaritiesCollectionView
    lazy var peculiaritiesCollectionView: UICollectionView = {
        let collection = UICollectionView(frame: contentView.bounds, collectionViewLayout: createLayoutPeculiaritiesCollection())
        
        collection.backgroundColor = .white
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        collection.decelerationRate = .fast
        collection.accessibilityIdentifier = "peculiaritiesCollectionView"
        
        //регистрация яйчеек
        collection.register(ComfortCollectionCell.self, forCellWithReuseIdentifier: ComfortCollectionCell.identifier)
        
        collection.dataSource = self
        collection.delegate = self
        
        contentView.addSubview(collection)
        
        return collection
    }()
    
    //MARK: - moreHotelStackView
    private let moreHotelStackView: UIStackView = {
        let but = UIButton(type: .system)
        but.translatesAutoresizingMaskIntoConstraints = false
        but.setTitle("Подробнее о номере", for: .normal)
        but.setTitleColor(UIColor(red: 0.05, green: 0.45, blue: 1, alpha: 1), for: .normal)
        but.titleLabel?.font = .init(name: "SFProDisplay-Medium", size: 16)
        
        let imageView = UIImageView(image: UIImage(named: "IconsBlue") ?? UIImage())
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        
        
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = .init(top: 5, left: 10, bottom: 5, right: .zero)
        stack.backgroundColor = #colorLiteral(red: 0.9137254902, green: 0.9450980392, blue: 0.9960784314, alpha: 1)
        stack.layer.cornerRadius = 5
        stack.spacing = -5
        
        stack.addArrangedSubview(but)
        stack.addArrangedSubview(imageView)
        
        return stack
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
    
    //MARK: - selectRoom
    let selectRoomButton: UIButton = {
        var but = UIButton(type: .system)
        but.translatesAutoresizingMaskIntoConstraints = false
        but.backgroundColor = #colorLiteral(red: 0.2, green: 0.4392156863, blue: 0.9647058824, alpha: 1)
        but.layer.cornerRadius = 10
        but.setTitle("Выбрать номер", for: .normal)
        but.setTitleColor(.white, for: .normal)
        
        return but
    }()
    
    private var countImage = 0
    
    //MARK: - init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraint()
        selectRoomButton.addTarget(self, action: #selector(selectRoomAction), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - createLayoutPhotoCollection
    private func createLayoutPhotoCollection() -> UICollectionViewLayout {
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
    
    //MARK: - createLayoutPeculiaritiesCollection
    private func createLayoutPeculiaritiesCollection() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { index, _ in
            switch index {
            case 0:
                let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(80), heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(38))
                
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                group.contentInsets = .init(top: 16, leading: .zero, bottom: .zero, trailing: .zero)
                group.interItemSpacing = .fixed(16)
                
                let section = NSCollectionLayoutSection(group: group)
                
                return section
            default:
                return NSCollectionLayoutSection(group: NSCollectionLayoutGroup(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(0), heightDimension: .absolute(0))))
            }
        }
    }
    
    //MARK: - setupConstraint
    private func setupConstraint() {
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
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 257)
        ])
        
        //titleLabel constraints
        mainView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: collectionView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor, constant: -16)
        ])
        
        //peculiaritiesCollectionView constraints
        mainView.addSubview(peculiaritiesCollectionView)
        NSLayoutConstraint.activate([
            peculiaritiesCollectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            peculiaritiesCollectionView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            peculiaritiesCollectionView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
        ])
                                    
        //moreHotelStackView constraints
        mainView.addSubview(moreHotelStackView)
        NSLayoutConstraint.activate([
            moreHotelStackView.topAnchor.constraint(equalTo: peculiaritiesCollectionView.bottomAnchor, constant: 8),
            moreHotelStackView.leadingAnchor.constraint(equalTo: peculiaritiesCollectionView.leadingAnchor),
            moreHotelStackView.widthAnchor.constraint(equalToConstant: 192),
            moreHotelStackView.heightAnchor.constraint(equalToConstant: 29)
        ])

        //priceLabel constraints
        mainView.addSubview(priceLabel)
        NSLayoutConstraint.activate([
            priceLabel.topAnchor.constraint(equalTo: moreHotelStackView.bottomAnchor, constant: 16),
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
        ])

        //priceForItLabel constraints
        mainView.addSubview(priceForItLabel)
        NSLayoutConstraint.activate([
            priceForItLabel.bottomAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: -3),
            priceForItLabel.leadingAnchor.constraint(equalTo: priceLabel.trailingAnchor, constant: 8)
        ])

        //selectRoomButton constraints
        mainView.addSubview(selectRoomButton)
        NSLayoutConstraint.activate([
            selectRoomButton.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 16),
            selectRoomButton.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            selectRoomButton.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            selectRoomButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    //MARK: - returnHeightContent
    func returnHeightContent(widthScreen: CGFloat, arrayOfStrings: [String]) -> CGFloat {
        var totalLines = 1
        var currentWidth: CGFloat = 0
        let cellWidth: CGFloat = 20
        let heightCell: CGFloat = 38
        //let spacingHeight: CGFloat = 16
        let spacingWidth: CGFloat = 16
        for str in arrayOfStrings {
            let font = UIFont.init(name: "SFProDisplay-Medium", size: 16)!
            let stringWidth = (str as NSString).size(withAttributes: [NSAttributedString.Key.font: font]).width
            
            //поместится ли элемент в строку
            if currentWidth < widthScreen {
                if currentWidth == 0 {
                    currentWidth += stringWidth + cellWidth
                } else {
                    currentWidth += stringWidth + cellWidth + spacingWidth
                }
            }
            
            //если элемент быльше ширины экрана, удалим его и добавим новую линию
            if currentWidth > widthScreen {
                currentWidth -= stringWidth
                totalLines += 1
                currentWidth = 0
            } else if currentWidth == widthScreen {
                totalLines += 1
                currentWidth = 0
            }
        }
        return (CGFloat(totalLines) * heightCell)
    }
    
    //MARK: - configurate
    func configurate(title: String, price: Int,
                     pricePer: String, countImage: Int) {
        titleLabel.text = title
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        guard let newPrice = numberFormatter.string(from: NSNumber(value: price)) else { return }

        self.priceLabel.text = "От \(newPrice.replacingOccurrences(of: ",", with: " "))₽"
        self.priceForItLabel.text = pricePer
        self.countImage = countImage
    }
    
    //MARK: - selectRoomAction
    @objc private func selectRoomAction(sender: UIButton) {
        guard let number = Int(sender.accessibilityIdentifier ?? "0") else { return }
        delegate?.roomWasSelect(index: number)
    }
}

//MARK: - extension
extension RoomTableCell: UICollectionViewDelegate,
                         UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.accessibilityIdentifier == "collectionView" {
            return dataSource?.countPhoto(indexTableRows: self.indexPath.row) ?? 0
        } else {
            return dataSource?.countPeculiarities(indexTableRows: self.indexPath.row) ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.accessibilityIdentifier == "collectionView" {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.identifier, for: indexPath) as? PhotoCell else { return UICollectionViewCell() }
            
            cell.contentView.accessibilityIdentifier = String(indexPath.row)
            cell.configurate(image: dataSource?.fetchPhoto(index: indexPath.row, indexTableRows: self.indexPath.row) ?? UIImage(), countPhoto: countImage)
            
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ComfortCollectionCell.identifier, for: indexPath) as? ComfortCollectionCell else { return UICollectionViewCell() }
            
            cell.configurate(title: dataSource?.fetchPeculiarities(index: indexPath.row, indexTableRows: self.indexPath.row) ?? "")
            
            return cell
        }
    }
}
