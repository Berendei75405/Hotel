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
                tableView.reloadData()
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
        viewModel.fetchBookingModel()
        setConstraints()
        setBackButton() 
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

//MARK: - extension
extension BookingViewController: UITableViewDelegate,
                                 UITableViewDataSource {
    //table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
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
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case .zero:
            return 170
        case 1:
            return 320
        default:
            return 0
        }
    }
}
