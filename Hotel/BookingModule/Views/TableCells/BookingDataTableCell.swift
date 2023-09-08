//
//  BookingDataTableCell.swift
//  Hotel
//
//  Created by Новгородцев Никита on 03.09.2023.
//

import UIKit

final class BookingDataTableCell: UITableViewCell {
    static let identifier = "BookingDataTableCell"
    
    //MARK: - mainView
    private let mainView: UIView = {
        var view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 20
        
        return view
    }()
    
    //MARK: - dataStackView
    private let dataStackView: UIStackView = {
        var stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = 16
        
        return stack
    }()
    
    //MARK: - init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
        createDataStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - configurate
    func configurate(hotelName: String, departure: String, arrivalCountry: String, tourDateStart: String, tourDateStop: String, numberOfNights: Int, room: String, nutrition: String) {
        
        for index in 0..<dataStackView.arrangedSubviews.count {
            guard let stackView = dataStackView.arrangedSubviews[index] as? UIStackView else { return }
            guard let label = stackView.arrangedSubviews[1] as? UILabel else { return }
            switch index {
            case .zero:
                label.text = departure
            case 1:
                label.text = arrivalCountry
            case 2:
                label.text = tourDateStart + "-" + tourDateStop
            case 3:
                label.text = String(numberOfNights)
            case 4:
                label.text = hotelName
            case 5:
                label.text = room
            case 6:
                label.text = nutrition
            default:
                return
            }
        }
    }
    
    //MARK: - createHorizontalStack
    private func createHorizontalStack(leftInfo: String) -> UIStackView {
        let horizontalStackView: UIStackView = {
            let leftLabel: UILabel = {
                let lab = UILabel()
                lab.translatesAutoresizingMaskIntoConstraints = false
                lab.font = .init(name: "SFProDisplay-Regular", size: 16)
                lab.textColor = UIColor(red: 0.51, green: 0.53, blue: 0.59, alpha: 1)
                lab.text = leftInfo
                
                return lab
            }()
            
            let rightLabel: UILabel = {
                let lab = UILabel()
                lab.translatesAutoresizingMaskIntoConstraints = false
                lab.font = .init(name: "SFProDisplay-Regular", size: 16)
                lab.textColor = .black
                lab.numberOfLines = 3
                lab.lineBreakMode = .byWordWrapping
                
                return lab
            }()
            
            let stack = UIStackView(arrangedSubviews: [leftLabel, rightLabel])
            stack.translatesAutoresizingMaskIntoConstraints = false
            stack.axis = .horizontal
            //stack.alignment = .center
            stack.distribution = .fillEqually
            
            return stack
        }()
        
        return horizontalStackView
    }
    
    //MARK: - createDataStackView
    private func createDataStackView() {
        let leftArray = ["Вылет из", "Страна, город", "Даты", "Кол-во ночей", "Отель", "Номер", "Питание"]
        for i in 0..<7 {
            let stack = createHorizontalStack(leftInfo: leftArray[i])
            dataStackView.addArrangedSubview(stack)
        }
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
        
        //dataStackView constraints
        mainView.addSubview(dataStackView)
        NSLayoutConstraint.activate([
            dataStackView.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 16),
            dataStackView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 16),
            dataStackView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -16),
            dataStackView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -16)
        ])
    }
}
