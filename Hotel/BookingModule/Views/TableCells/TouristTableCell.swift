//
//  TouristTableCell.swift
//  Hotel
//
//  Created by Новгородцев Никита on 03.09.2023.
//

import UIKit

protocol TouristTableCellDelegate: AnyObject {
    func closeButton(index: Int)
    func correct(indexCell: Int, indexTextField: Int, string: String)
}

final class TouristTableCell: UITableViewCell {
    static let identifier = "TouristTableCell"
    private let titlesArray = ["Имя", "Фамилия", "Дата рождения", "Гражданство", "Номер загранпаспорта", "Срок действия загранпаспорта"]
    
    private var height: CGFloat = 0
    
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
        lab.text = "Первый турист"
        
        return lab
    }()
    
    //MARK: - closeButton
    let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "iconsTop"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = #colorLiteral(red: 0.9303779006, green: 0.9571331143, blue: 0.9970633388, alpha: 1)
        button.layer.cornerRadius = 6
        
        return button
    }()
    
    //MARK: - stackView
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 8
        
        return stackView
    }()
    
    weak var delegate: TouristTableCellDelegate?
    
    //MARK: - init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
        closeButton.addTarget(self, action: #selector(closeButtonAction(sender:)),
                              for: .touchUpInside)
        createMainStackView()
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
            titleLabel.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 16)
        ])
        
        //closeButton constraints
        mainView.addSubview(closeButton)
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 13),
            closeButton.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -16),
            closeButton.heightAnchor.constraint(equalToConstant: 32),
            closeButton.widthAnchor.constraint(equalToConstant: 32)
        ])
        
        //stackView constraints
        mainView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -16),
            stackView.heightAnchor.constraint(equalToConstant: 352)
        ])
        
    }
    
    //MARK: - createMainStackView
    private func createMainStackView() {
        for index in 0..<titlesArray.count {
            let stackLitle = createLitleStackView(title: self.titlesArray[index], index: index)
            stackView.addArrangedSubview(stackLitle)
        }
    }
    
    //MARK: - createLitleStackView
    private func createLitleStackView(title: String, index: Int) -> UIStackView {
        let textField: UITextField = {
            let textF = UITextField()
            textF.translatesAutoresizingMaskIntoConstraints = false
            textF.accessibilityIdentifier = "\(index)"
            textF.delegate = self
            textF.placeholder = title
            
            return textF
        }()
        
        let stackView: UIStackView = {
            let stack = UIStackView()
            stack.translatesAutoresizingMaskIntoConstraints = true
            stack.axis = .vertical
            stack.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.98, alpha: 1)
            stack.layoutMargins = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: .zero)
            stack.isLayoutMarginsRelativeArrangement = true
            stack.layer.cornerRadius = 10
            
            return stack
        }()
        stackView.addArrangedSubview(textField)
        stackView.heightAnchor.constraint(equalToConstant: 52).isActive = true
        
        return stackView
    }
    
    //MARK: - configurate
    func configurate(height: CGFloat, title: String) {
        self.height = height
        if height == 436 {
            closeButton.setImage(UIImage(named: "IconsBottom"), for: .normal)
            stackView.isHidden = false
        } else {
            closeButton.setImage(UIImage(named: "iconsTop"), for: .normal)
            stackView.isHidden = true
        }
        self.titleLabel.text = title
    }
    
    //MARK: - closeButton
    @objc private func closeButtonAction(sender: UIButton) {
        guard let index = Int(contentView.accessibilityIdentifier ?? "") else { return }
        delegate?.closeButton(index: index)
    }
}

//MARK: - extension
extension TouristTableCell: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let text = textField.text, !text.isEmpty  {

        } else {
            //проверка индекса textField
            guard let index = Int(textField.accessibilityIdentifier ?? "") else { return }
            if stackView.arrangedSubviews.indices.contains(index) {
                guard let verticalStack = stackView.arrangedSubviews[index] as? UIStackView else { return }
                
                //создание элемента который нужно добавить
                let lab = UILabel()
                lab.font = UIFont(name: "SFProDisplay-Regular", size: 12)
                lab.translatesAutoresizingMaskIntoConstraints = false
                lab.textColor = UIColor(red: 0.66, green: 0.67, blue: 0.72, alpha: 1)
                lab.text = textField.placeholder
                
                verticalStack.insertArrangedSubview(lab, at: 0)
            }
        }
    }
    
    //закрытие поля ввода
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let index = Int(textField.accessibilityIdentifier ?? "") else { return }
        guard let indexCell = Int(contentView.accessibilityIdentifier ?? "") else { return }
        
        //логика добавление UILabel
        if let text = textField.text, !text.isEmpty  {
            guard let litleStack = stackView.arrangedSubviews[index] as? UIStackView else { return }
            litleStack.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.98, alpha: 1)
            
            
        } else {
            //проверка индекса textField
            guard let index = Int(textField.accessibilityIdentifier ?? "") else { return }
            if stackView.arrangedSubviews.indices.contains(index) {
                guard let verticalStack = stackView.arrangedSubviews[index] as? UIStackView else { return }
                
                guard let label = verticalStack.arrangedSubviews[0] as? UILabel else { return }
                
                verticalStack.removeArrangedSubview(label)
                label.removeFromSuperview()
            }
        }
        delegate?.correct(indexCell: indexCell - 3, indexTextField: index, string: textField.text ?? "")
    }
}
