//
//  AddTouristTableCell.swift
//  Hotel
//
//  Created by Новгородцев Никита on 04.09.2023.
//

import UIKit

protocol AddTouristTableCellDelegate: AnyObject {
    func addTourist()
}

final class AddTouristTableCell: UITableViewCell {
    static let identifier = "AddTouristTableCell"
    
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
        lab.text = "Добавить туриста"
        
        return lab
    }()
    
    //MARK: - addButton
    private let addButton: UIButton = {
        let button = UIButton()        
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(red: 0.05, green: 0.45, blue: 1, alpha: 1)
        button.tintColor = .white
        button.layer.cornerRadius = 6
        
        return button
    }()
    
    weak var delegate: AddTouristTableCellDelegate?
    
    //MARK: - init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
        addButton.addTarget(self, action: #selector(addButtonAction), for: .touchUpInside)
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
        
        //titleLabel constraints
        mainView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 13)
        ])
        
        //addButton constraints
        mainView.addSubview(addButton)
        NSLayoutConstraint.activate([
            addButton.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 13),
            addButton.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -16),
            addButton.heightAnchor.constraint(equalToConstant: 32),
            addButton.widthAnchor.constraint(equalToConstant: 32)
        ])
    }
    
    //MARK: - addButtonAction
    @objc private func addButtonAction() {
        delegate?.addTourist()
    }
}
