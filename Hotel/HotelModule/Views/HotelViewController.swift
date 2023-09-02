//
//  ViewController.swift
//  Hotel
//
//  Created by Новгородцев Никита on 31.08.2023.
//

import UIKit
import Combine

final class HotelViewController: UIViewController {
    var viewModel: HotelViewModelProtocol!
    private var cancellable = Set<AnyCancellable>()
    
    deinit {
        print("HotelViewController")
    }
    
    //MARK: - collectionView
    private lazy var tableView: UITableView = {
        var tableView = UITableView(frame: .zero, style: .plain)
        
        tableView.backgroundColor = #colorLiteral(red: 0.9719608426, green: 0.9722560048, blue: 0.9813567996, alpha: 1)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.separatorStyle = .none
        
        //регистрация яйчеек
        tableView.register(HotelPhotoAndPriceCell.self, forCellReuseIdentifier: HotelPhotoAndPriceCell.identifier)
        
        tableView.register(DescriptionTableViewCell.self, forCellReuseIdentifier: DescriptionTableViewCell.identifier)
        
        view.addSubview(tableView)
        
        return tableView
    }()
    
    //обновление table
    private var tableState: TableState = .initial {
        didSet {
            switch tableState {
            case .success:
                tableView.reloadData()
                tableView.dataSource = self
                tableView.delegate = self
            case .failure:
                print("failure")
            case .initial:
                print("tableView init")
            }
        }
    }
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetchHotel()
        updateState()
        setConstraints()
        self.navigationItem.title = "Отель"
    }
    
    //MARK: - updateState
    private func updateState() {
        viewModel.updateTableState.sink { [unowned self] state in
            self.tableState = state
        }.store(in: &cancellable)
    }
    
    //MARK: - createLayout
    private func createLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { index, _ in
            switch index {
            case .zero:
                let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(self.view.frame.width), heightDimension: .absolute(600))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = .init(top: .zero, leading: 16, bottom: .zero, trailing: 16)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(400), heightDimension: .absolute(100))
                
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                
                return section
            default:
                return NSCollectionLayoutSection(group: NSCollectionLayoutGroup(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(.zero), heightDimension: .absolute(.zero))))
            }
        }
    }
    
    //MARK: - setConstraints
    private func setConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension HotelViewController: UITableViewDelegate,
                               UITableViewDataSource,
                               HotelPhotoAndPriceCellDataSource, DescriptionTableViewCellDataSource {
    
    //MARK: - table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case .zero:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HotelPhotoAndPriceCell.identifier, for: indexPath) as? HotelPhotoAndPriceCell else { return UITableViewCell() }
            
            cell.dataSource = self
            cell.confugurate(rating: viewModel.hotel?.rating ?? 0, ratingName: viewModel.hotel?.ratingName ?? "", title: viewModel.hotel?.name ?? "", address: viewModel.hotel?.adress ?? "", price: viewModel.hotel?.minimalPrice ?? 0, priceForIt: viewModel.hotel?.priceForIt ?? "")
            cell.selectionStyle = .none
            
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DescriptionTableViewCell.identifier, for: indexPath) as? DescriptionTableViewCell else { return UITableViewCell() }
            
            cell.dataSource = self
            cell.configurate(description: viewModel.hotel?.aboutTheHotel.description ?? "")
            cell.collectionView.heightAnchor.constraint(equalToConstant: cell.returnHeightContent(widthScreen: cell.contentView.frame.width - 32, arrayOfStrings: viewModel.hotel?.aboutTheHotel.peculiarities ?? [""])).isActive = true
            
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case .zero:
            return 490
        case 1:
            return 500
        default:
            return 0
        }
    }
    
    //MARK: - HotelPhotoAndPriceCellDataSource
    func photoCount() -> Int {
        return viewModel.imagesData.count
    }
    
    func fetchPhoto(index: Int) -> UIImage {
        return UIImage(data: viewModel.imagesData[index]) ?? UIImage()
    }
    
    //MARK: - DescriptionTableViewCellDataSource
    func countComfort() -> Int {
        return viewModel.hotel?.aboutTheHotel.peculiarities.count ?? 0
    }
    
    func fetchComfort(index: Int) -> String {
        return viewModel.hotel?.aboutTheHotel.peculiarities[index] ?? ""
    }
    
}

