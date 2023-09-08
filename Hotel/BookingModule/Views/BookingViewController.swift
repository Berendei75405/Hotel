//
//  BookingViewController.swift
//  Hotel
//
//  Created by Новгородцев Никита on 02.09.2023.
//

import UIKit
import Combine

final class BookingViewController: UIViewController {
    var viewModel: BookingViewModelProtocol!
    var select: String = ""
    var tabBar: TabBarController?
    
    deinit {
        print("BookingViewController deinit")
    }
    private var cancellable = Set<AnyCancellable>()

    //MARK: - tableView
    private lazy var tableView: UITableView = {
        var tableView = UITableView(frame: .zero, style: .plain)

        tableView.backgroundColor = #colorLiteral(red: 0.9719608426, green: 0.9722560048, blue: 0.9813567996, alpha: 1)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.separatorStyle = .none

        //регистрация яйчеек
        tableView.register(HotelTableCell.self, forCellReuseIdentifier: HotelTableCell.identifier)
        
        tableView.register(BookingDataTableCell.self, forCellReuseIdentifier: BookingDataTableCell.identifier)
        
        tableView.register(BuyerTableCell.self, forCellReuseIdentifier: BuyerTableCell.identifier)
        
        tableView.register(TouristTableCell.self, forCellReuseIdentifier: TouristTableCell.identifier)
        
        tableView.register(AddTouristTableCell.self, forCellReuseIdentifier: AddTouristTableCell.identifier)
        
        tableView.register(TotalPriceTableCell.self, forCellReuseIdentifier: TotalPriceTableCell.identifier)

        view.addSubview(tableView)

        return tableView
    }()
    
    //MARK: - tableState
    private var tableState: TableState = .initial {
        didSet {
            switch tableState {
            case .success:
                tableView.dataSource = self
                tableView.delegate = self
                let numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = .decimal
                guard let newPrice = numberFormatter.string(from: NSNumber(value: viewModel.totalPrice()))?.replacingOccurrences(of: ",", with: " ") else { return }
                let price = "Оплатить \(newPrice) ₽"
                tabBar?.button.setTitle(price, for: .normal)
                tableView.reloadData()
            case .failure:
                print("failure")
            case .initial:
                print("tableView init")
            }
        }
    }
    
    //MARK: - closeKeyboardTap
    private lazy var closeKeyboardTap = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super .viewDidLoad()
        viewModel.fetchBookingModel()
        setConstraints()
        setBackButton() 
        updateState()
        view.addGestureRecognizer(closeKeyboardTap)
        tabBar?.button.addTarget(self, action: #selector(buy(sender:)), for: .touchUpInside)
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
    
    //MARK: - closeKeyboard
    @objc private func closeKeyboard() {
        view.endEditing(true)
    }
    
    //MARK: - buy
    @objc private func buy(sender: UIButton) {
        let check = viewModel.chechAllTextFields()
        var indexCell = 0
        //проверка заполнены ли ячейки
        if check.0.isEmpty && check.1.isEmpty {
            viewModel.showOrderModule()
            sender.setTitle("Cупер!", for: .normal)
        } else {
            //проверка полей phone and email
            if !check.1.isEmpty {
                guard let cell = tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as? BuyerTableCell else { return }
                for i in check.1 {
                    guard let litleStack = cell.stackView.arrangedSubviews[i] as? UIStackView else { return }
                    let color = #colorLiteral(red: 0.9450980392, green: 0.4352941176, blue: 0.4156862745, alpha: 0.8545386905)
                    litleStack.backgroundColor = color
                }
            }
            //проверка туристов
            if !check.0.isEmpty {
                for item in check.0 {
                    indexCell = item[0] + 3
                    guard let cell = tableView.cellForRow(at: IndexPath(row: indexCell, section: 0)) as? TouristTableCell else { return }
                    guard let litleStack = cell.stackView.arrangedSubviews[item[1]] as? UIStackView else { return }
                    let color = #colorLiteral(red: 0.9450980392, green: 0.4352941176, blue: 0.4156862745, alpha: 0.8545386905)
                    litleStack.backgroundColor = color
                }
            }
        }
    }
}

//MARK: - extension
extension BookingViewController: UITableViewDelegate,
                                 UITableViewDataSource, BuyerTableCellDelegate, TouristTableCellDelegate, AddTouristTableCellDelegate {
    //table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5 + viewModel.tourist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case .zero:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HotelTableCell.identifier, for: indexPath) as? HotelTableCell else { return UITableViewCell() }
            
            //configurate
            cell.configurate(rating: viewModel.bookingModel?.horating ?? 0, ratingName: viewModel.bookingModel?.ratingName ?? "", title: viewModel.bookingModel?.hotelName ?? "", address: viewModel.bookingModel?.hotelAdress ?? "")
            
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: BookingDataTableCell.identifier, for: indexPath) as? BookingDataTableCell else { return UITableViewCell() }
            
            //configurate
            cell.configurate(hotelName: viewModel.bookingModel?.hotelName ?? "", departure: viewModel.bookingModel?.departure ?? "", arrivalCountry: viewModel.bookingModel?.arrivalCountry ?? "", tourDateStart: viewModel.bookingModel?.tourDateStart ?? "", tourDateStop: viewModel.bookingModel?.tourDateStop ?? "", numberOfNights: viewModel.bookingModel?.numberOfNights ?? 0, room: viewModel.bookingModel?.room ?? "", nutrition: viewModel.bookingModel?.nutrition ?? "")
            
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: BuyerTableCell.identifier, for: indexPath) as? BuyerTableCell else { return UITableViewCell() }
            
            //configurate
            cell.delegate = self
            
            return cell
        default:
            break
        }
        
        let countTourist = viewModel.tourist.count + 2
        if (indexPath.row >= 3) && (countTourist >= indexPath.row) {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TouristTableCell.identifier, for: indexPath) as? TouristTableCell else { return UITableViewCell() }
            
            cell.contentView.accessibilityIdentifier = String(indexPath.row)
            //configurate
            cell.delegate = self

            if viewModel.cellTitles.indices.contains(indexPath.row - 3) {
                cell.configurate(height: viewModel.returnCellHeight(index: indexPath.row), title:  viewModel.cellTitles[indexPath.row - 3])
            } else {
                cell.configurate(height: viewModel.returnCellHeight(index: indexPath.row), title: "")
            }
            
            return cell
        } else {
            if indexPath.row == viewModel.tourist.count + 3 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: AddTouristTableCell.identifier, for: indexPath) as? AddTouristTableCell else { return UITableViewCell() }
                
                cell.delegate = self
                
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: TotalPriceTableCell.identifier, for: indexPath) as? TotalPriceTableCell else { return UITableViewCell() }
                
                //configurate
                cell.configurate(tourPrice: viewModel.bookingModel?.tourPrice ?? 0, fuelCharge: viewModel.bookingModel?.fuelCharge ?? 0, serviceCharge: viewModel.bookingModel?.serviceCharge ?? 0, totalPrice: viewModel.totalPrice())
                
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.returnCellHeight(index: indexPath.row)
    }
    
    //MARK: - BuyerTableCellDelegate
    func correctPhoneNumber(string: String) -> Bool {
        return viewModel.validateNumberPhone(string: string)
    }
    
    func correctEmail(string: String) -> Bool {
        return viewModel.validateEmail(string: string)
    }
    
    //MARK: - TouristTableCellDelegate
    func closeButton(index: Int) {
        if viewModel.returnCellHeight(index: index) == 436 {
            viewModel.changeHeight(index: index, heightNew: 64)
        } else {
            viewModel.changeHeight(index: index, heightNew: 436)
        }
        var closedCell = 0
        for i in 0...viewModel.tourist.count + 5 {
            if viewModel.returnCellHeight(index: i) == 64 {
                closedCell += 1
            }
        }
        
        if closedCell == 2 && viewModel.returnCellHeight(index: index) == 436 {
            tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        } else {
            tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        }
    }
    
    func correct(indexCell: Int, indexTextField: Int, string: String) {
        viewModel.addTouristInfo(indexCell: indexCell, indexTextField: indexTextField, string: string)
    }
    
    //MARK: - AddTouristTableCellDelegate
    func addTourist() {
        var indexCell = 0
        if let brokenCell = viewModel.addTourist() {
            for item in brokenCell {
                indexCell = item[0] + 3
                guard let cell = tableView.cellForRow(at: IndexPath(row: indexCell, section: 0)) as? TouristTableCell else { return }
                guard let litleStack = cell.stackView.arrangedSubviews[item[1]] as? UIStackView else { return }
                let color = #colorLiteral(red: 0.9450980392, green: 0.4352941176, blue: 0.4156862745, alpha: 0.8545386905)
                litleStack.backgroundColor = color
            }
        } else {
            let indexPath = IndexPath(row: 2 + viewModel.tourist.count, section: 0)
//            let indexCellsTourist = [IndexPath(row: <#T##Int#>, section: 0)]
            tableView.insertRows(at: [indexPath], with: .automatic)
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
}
