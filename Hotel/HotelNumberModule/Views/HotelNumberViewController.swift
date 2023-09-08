//
//  HotelNumberViewController.swift
//  Hotel
//
//  Created by Новгородцев Никита on 01.09.2023.
//

import UIKit
import Combine

final class HotelNumberViewController: UIViewController {
    deinit {
        print("HotelNumberViewController deinit")
    }
    
    var viewModel: HotelNumberViewModelProtocol!
    var select: String = ""
    private var cancellable = Set<AnyCancellable>()
    private var collectionHeights = [CGFloat]()
    private var titlesHeight = [CGFloat]()
    
    //MARK: - tableView
    private lazy var tableView: UITableView = {
        var tableView = UITableView(frame: .zero, style: .plain)
        
        tableView.backgroundColor = #colorLiteral(red: 0.9719608426, green: 0.9722560048, blue: 0.9813567996, alpha: 1)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.separatorStyle = .none
        
        //регистрация яйчеек
        tableView.register(RoomTableCell.self, forCellReuseIdentifier: RoomTableCell.identifier)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        view.addSubview(tableView)
        
        return tableView
    }()
    
    //MARK: - tableState
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
        super .viewDidLoad()
        viewModel.fetchRoomArray()
        setBackButton()
        setConstraints()
        updateState()
    }
    
    //MARK: - updateState
    private func updateState() {
        viewModel.updateTableState.sink { [unowned self] state in
            self.tableState = state
        }.store(in: &cancellable)
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
extension HotelNumberViewController: UITableViewDelegate,
                                     UITableViewDataSource, RoomTableCellDataSourceProtocol, RoomTableCellDelegateProtocol {
    //MARK: - tableProtocol
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        for index in 0..<viewModel.imagesArray.count {
            let filtredArray = viewModel.imagesArray[index].filter {UIImage(data: $0) != nil }
            if !filtredArray.isEmpty {
                viewModel.imagesArray[index] = filtredArray
            }
        }
        return viewModel.roomArray?.rooms.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RoomTableCell.identifier, for: indexPath) as? RoomTableCell else { return UITableViewCell() }
        
        //задаем индекс яйчейки
        cell.indexPath = indexPath
        cell.selectRoomButton.accessibilityIdentifier = "\(indexPath.row)"
        
        //конфигурируем яйчейку
        cell.configurate(title: viewModel.roomArray?.rooms[indexPath.row].name ?? "",
                         price: viewModel.roomArray?.rooms[indexPath.row].price ?? 0, pricePer: viewModel.roomArray?.rooms[indexPath.row].pricePer ?? "", countImage: viewModel.imagesArray[indexPath.row].count)
        
        //подписываемся на протоколы
        cell.dataSource = self
        cell.delegate = self
        
        //узнаем высоту контента для размеров яйчейки
        let height = cell.returnHeightContent(widthScreen: cell.contentView.frame.width - 32, arrayOfStrings: viewModel.roomArray?.rooms[indexPath.row].peculiarities ?? [""])
        cell.peculiaritiesCollectionView.heightAnchor.constraint(equalToConstant: height).isActive = true
        let font = UIFont.init(name: "SFProDisplay-Medium", size: 22)!
        let stringWidth = ((viewModel.roomArray?.rooms[indexPath.row].name ?? "") as NSString).size(withAttributes: [NSAttributedString.Key.font: font]).width
        if stringWidth <= cell.contentView.frame.width - 32 {
            self.titlesHeight.append(26)
        } else {
            self.titlesHeight.append(52)
        }
        self.collectionHeights.append(height)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return collectionHeights.indices.contains(indexPath.row) ?  collectionHeights[indexPath.row] + titlesHeight[indexPath.row] + 460 : 550
    }
    
    //MARK: - RoomTableCellDataSourceProtocol
    func countPhoto(indexTableRows: Int) -> Int {
        return viewModel.imagesArray[indexTableRows].count 
    }
    
    func fetchPhoto(index: Int, indexTableRows: Int) -> UIImage {
        return UIImage(data: viewModel.imagesArray[indexTableRows][index]) ?? UIImage(systemName: "questionmark") ?? UIImage()
    }
    
    func countPeculiarities(indexTableRows: Int) -> Int {
        return viewModel.roomArray?.rooms[indexTableRows].peculiarities.count ?? 0
    }
    
    func fetchPeculiarities(index: Int, indexTableRows: Int) -> String {
        return viewModel.roomArray?.rooms[indexTableRows].peculiarities[index] ?? ""
    }
    
    //MARK: - RoomTableCellDelegateProtocol
    func roomWasSelect(index: Int) {
        viewModel.showBooking()
    }
}
