//
//  TotalPriceTableCell.swift
//  Hotel
//
//  Created by Новгородцев Никита on 04.09.2023.
//

import UIKit

final class TotalPriceTableCell: UITableViewCell {
    static let identifier = "TotalPriceTableCell"
    
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
            stack.distribution = .equalSpacing
            
            return stack
        }()
        
        return horizontalStackView
    }
    
    //MARK: - createDataStackView
    private func createDataStackView() {
        let leftArray = ["Тур", "Топливный сбор", "Сервисный сбор", "К оплате"]
        for i in 0..<4 {
            let stack = createHorizontalStack(leftInfo: leftArray[i])
            dataStackView.addArrangedSubview(stack)
        }
    }
    
    //MARK: - configurate
    func configurate(tourPrice: Int, fuelCharge: Int, serviceCharge: Int, totalPrice: Int) {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        for index in 0..<dataStackView.arrangedSubviews.count {
            guard let stackView = dataStackView.arrangedSubviews[index] as? UIStackView else { return }
            guard let label = stackView.arrangedSubviews[1] as? UILabel else { return }
            switch index {
            case .zero:
                guard let newPrice = numberFormatter.string(from: NSNumber(value: tourPrice))?.replacingOccurrences(of: ",", with: " ") else { return }
                label.text = "\(newPrice) ₽"
            case 1:
                guard let newPrice = numberFormatter.string(from: NSNumber(value: fuelCharge))?.replacingOccurrences(of: ",", with: " ") else { return }
                label.text = "\(newPrice) ₽"
            case 2:
                guard let newPrice = numberFormatter.string(from: NSNumber(value: serviceCharge))?.replacingOccurrences(of: ",", with: " ") else { return }
                label.text = "\(newPrice) ₽"
            case 3:
                guard let newPrice = numberFormatter.string(from: NSNumber(value: totalPrice))?.replacingOccurrences(of: ",", with: " ") else { return }
                label.text = "\(newPrice) ₽"
                label.textColor = UIColor(red: 0.05, green: 0.45, blue: 1, alpha: 1)
            default:
                return
            }
        }
    }
}
