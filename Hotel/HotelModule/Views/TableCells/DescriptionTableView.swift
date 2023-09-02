//
//  DescriptionTableView.swift
//  Hotel
//
//  Created by Новгородцев Никита on 31.08.2023.
//

import UIKit

protocol DescriptionTableViewCellDataSource: AnyObject {
    func countComfort() -> Int
    func fetchComfort(index: Int) -> String
}

final class DescriptionTableViewCell: UITableViewCell {
    static let identifier = "DescriptionTableViewCell"
    
    weak var dataSource: DescriptionTableViewCellDataSource?
    
    //MARK: - mainView
    private let mainView: UIView = {
        var view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 20
        
        return view
    }()
    
    //MARK: - titleLabel
    private let titleLabel: UILabel = {
        let lab = UILabel()
        lab.font = UIFont(name: "SFProDisplay-Medium", size: 22)
        lab.translatesAutoresizingMaskIntoConstraints = false
        lab.textColor = .black
        lab.text = "Об отеле"
        lab.lineBreakMode = .byWordWrapping
        lab.numberOfLines = 0
        
        return lab
    }()
    
    //MARK: - collectionView
    lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: contentView.bounds, collectionViewLayout: createLayout())
        
        collection.backgroundColor = .white
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        collection.isScrollEnabled = false
        collection.decelerationRate = .fast
        
        //регистрация яйчеек
        collection.register(ComfortCollectionCell.self, forCellWithReuseIdentifier: ComfortCollectionCell.identifier)
        
        collection.dataSource = self
        collection.delegate = self
        
        contentView.addSubview(collection)
        
        return collection
    }()
    
    //MARK: - descriptionLabel
    private let descriptionLabel: UILabel = {
        let lab = UILabel()
        lab.font = UIFont(name: "SFProDisplay-Regular", size: 16)
        lab.translatesAutoresizingMaskIntoConstraints = false
        lab.textColor = .black
        lab.lineBreakMode = .byWordWrapping
        lab.numberOfLines = 0
        
        return lab
    }()
    
    //MARK: - aboutHotelMainStackView
    private lazy var aboutHotelMainStackView: UIStackView = {
        var stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 10
        stack.alignment = .fill
        stack.backgroundColor = #colorLiteral(red: 0.9843137255, green: 0.9843137255, blue: 0.9882352941, alpha: 1)
        stack.layer.cornerRadius = 10
        stack.layoutMargins = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        stack.isLayoutMarginsRelativeArrangement = true
        mainView.addSubview(stack)
        
        return stack
    }()
    
    
    //MARK: - init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
        createCellStackView()
        contentView.backgroundColor = #colorLiteral(red: 0.9647058824, green: 0.9647058824, blue: 0.9764705882, alpha: 1)
    }
    
    //MARK: - configurate
    func configurate(description: String) {
        descriptionLabel.text = description 
    }
    
    //MARK: - setupConstraints
    private func setupConstraints() {
        //mainView contraints
        contentView.addSubview(mainView)
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            mainView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        //titleLabel constraints
        mainView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
        
        //collectionView contraints
        mainView.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor)
        ])
        
        //descriptionLabel constraints
        mainView.addSubview(descriptionLabel)
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 12),
            descriptionLabel.leadingAnchor.constraint(equalTo: collectionView.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor)
        ])
        
        //aboutHotelMainStackView constraints
        NSLayoutConstraint.activate([
            aboutHotelMainStackView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
            aboutHotelMainStackView.leadingAnchor.constraint(equalTo: descriptionLabel.leadingAnchor),
            aboutHotelMainStackView.trailingAnchor.constraint(equalTo: descriptionLabel.trailingAnchor),
            aboutHotelMainStackView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -16)
        ])
        
    }
    
    //MARK: - createSubviewsVerticalStackView
    private func createSubviewsVerticalStackView(title: String, description: String, separatorLineIsHiden: Bool) -> UIStackView {
        //MARK: - verticalStackView
        let verticalStackView: UIStackView = {
            let stack = UIStackView()
            stack.axis = .vertical
            stack.translatesAutoresizingMaskIntoConstraints = false
            stack.layoutMargins = UIEdgeInsets(top: .zero, left: 12, bottom: .zero, right: .zero)
            stack.isLayoutMarginsRelativeArrangement = true
            
            return stack
        }()
        
        let titleLab: UILabel = {
            let lab = UILabel()
            lab.font = UIFont(name: "SFProDisplay-Medium", size: 16)
            lab.translatesAutoresizingMaskIntoConstraints = false
            lab.textColor = .black
            lab.text = title
            lab.lineBreakMode = .byWordWrapping
            lab.numberOfLines = 0
            
            return lab
        }()
        
        let descrLabel: UILabel = {
            let lab = UILabel()
            lab.font = UIFont(name: "SFProDisplay-Medium", size: 14)
            lab.translatesAutoresizingMaskIntoConstraints = false
            lab.textColor = UIColor(red: 0.51, green: 0.53, blue: 0.59, alpha: 1)
            lab.text = description
            lab.lineBreakMode = .byWordWrapping
            lab.numberOfLines = 0
            
            return lab
        }()
        
        let separatorLineView: UIView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.backgroundColor = UIColor(red: 0.51, green: 0.529, blue: 0.588, alpha: 0.15)
            
            return view
        }()
        separatorLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        verticalStackView.addArrangedSubview(titleLab)
        verticalStackView.addArrangedSubview(descrLabel)
        if separatorLineIsHiden == false {
            verticalStackView.addArrangedSubview(separatorLineView)
        }
        return verticalStackView
    }
    
    //MARK: - createSubviewsHorizontalStackView
    private func createSubviewsHorizontalStackView(image: UIImage, title: String, description: String, separatorLineIsHiden: Bool) -> UIStackView {
        //MARK: - horizontalStackView
        let horizontalStackView: UIStackView = {
            let stack = UIStackView()
            stack.axis = .horizontal
            stack.translatesAutoresizingMaskIntoConstraints = false
            stack.alignment = .fill
            
            return stack
        }()
        let verticalStackView = createSubviewsVerticalStackView(title: title, description: description, separatorLineIsHiden: separatorLineIsHiden)
        
        let image: UIImageView = {
            let img = UIImageView()
            img.translatesAutoresizingMaskIntoConstraints = false
            img.contentMode = .scaleAspectFit
            img.image = image
            
            return img
        }()
        let goImage: UIImageView = {
            let img = UIImageView()
            img.translatesAutoresizingMaskIntoConstraints = false
            img.contentMode = .scaleAspectFit
            img.image = UIImage(named: "Icons")
            
            return img
        }()
        image.heightAnchor.constraint(equalToConstant: 50).isActive = true
        image.widthAnchor.constraint(equalToConstant: 24).isActive = true
        goImage.heightAnchor.constraint(equalToConstant: 50).isActive = true
        goImage.widthAnchor.constraint(equalToConstant: 24).isActive = true
        horizontalStackView.addArrangedSubview(image)
        horizontalStackView.addArrangedSubview(verticalStackView)
        horizontalStackView.addArrangedSubview(goImage)
        aboutHotelMainStackView.addArrangedSubview(horizontalStackView)
        
        return horizontalStackView
    }
    
    //MARK: - createCellStackView
    private func createCellStackView() {
        let titles = ["Удобства", "Что включено", "Что не включено"]
        let descr = "Cамое необходимое"
        let imagesArray = [UIImage(named: "emoji-happy") ?? UIImage(),
                           UIImage(named: "tick-square") ?? UIImage(),
                           UIImage(named: "close-square") ?? UIImage()]
        for i in 0..<3 {
            if i == 2 {
                let horizontalStack = createSubviewsHorizontalStackView(image: imagesArray[i], title: titles[i], description: descr, separatorLineIsHiden: true)
                aboutHotelMainStackView.addArrangedSubview(horizontalStack)
            } else {
                let horizontalStack = createSubviewsHorizontalStackView(image: imagesArray[i], title: titles[i], description: descr, separatorLineIsHiden: false)
                aboutHotelMainStackView.addArrangedSubview(horizontalStack)
            }
        }
    }

//MARK: - createLayout
private func createLayout() -> UICollectionViewLayout {
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DescriptionTableViewCell: UICollectionViewDelegate,
                                    UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?.countComfort() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ComfortCollectionCell.identifier, for: indexPath) as? ComfortCollectionCell else { return UICollectionViewCell() }
        
        cell.configurate(title: dataSource?.fetchComfort(index: indexPath.row) ?? "")
        cell.layer.cornerRadius = 5
        
        return cell
    }
    
    
}
