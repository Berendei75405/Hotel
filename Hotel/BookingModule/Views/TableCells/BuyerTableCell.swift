//
//  BuyerTableCell.swift
//  Hotel
//
//  Created by Новгородцев Никита on 03.09.2023.
//

import UIKit

protocol BuyerTableCellDelegate: AnyObject {
    func correctPhoneNumber(string: String) -> Bool
    func correctEmail(string: String) -> Bool
}

final class BuyerTableCell: UITableViewCell {
    static let identifier = "BuyerTableCell"
    private let titlesArray = ["Номер телефона", "Почта"]
    
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
        lab.text = "Информация о покупателе"
        
        return lab
    }()
    
    //MARK: - stackView
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 8
        
        return stackView
    }()
    
    //MARK: - descriptionLabel
    private let descriptionLabel: UILabel = {
        let lab = UILabel()
        lab.font = UIFont(name: "SFProDisplay-Regular", size: 14)
        lab.translatesAutoresizingMaskIntoConstraints = false
        lab.textColor = UIColor(red: 0.51, green: 0.53, blue: 0.59, alpha: 1)
        lab.lineBreakMode = .byWordWrapping
        lab.numberOfLines = 0
        lab.text = "Эти данные никому не передаются. После оплаты мы вышли чек на указанный вами номер и почту"
        
        return lab
    }()
    
    weak var delegate: BuyerTableCellDelegate?
    
    //MARK: - init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
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
            titleLabel.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -16)
        ])
        
        //stackView constraints
        mainView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 112)
        ])
        
        //descriptionLabel constraints
        mainView.addSubview(descriptionLabel)
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -16)
        ])
        
    }
    
    //MARK: - createMainStackView
    private func createMainStackView() {
        for index in 0..<2 {
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
    
    //MARK: - applyPhoneNumberMask
    private func applyPhoneNumberMask(textField: UITextField, replacementString string: String) -> Bool {
        guard var txt = textField.text else { return false }
        //допускаются только такие символы к вводу
        let allowedCharacters = CharacterSet(charactersIn:"0123456789")
        let characterSet = CharacterSet(charactersIn: string)
        let symbolIsCorrect = allowedCharacters.isSuperset(of: characterSet)
        
        //проверка на корректность символа
        if symbolIsCorrect == true {
            //проверка на первый символ
            if txt.isEmpty {
                txt = "+7 (***) ***-**-**"
                textField.text = txt
            }
            
            //проверка на содержание "*"
            if txt.contains("*") && !string.isEmpty {
                guard let index = txt.firstIndex(of: "*") else { return false }
                let newIndex = txt.distance(from: txt.startIndex, to: index)
                
                txt.remove(at: index)
                txt.insert(Character(string), at: index)
                guard let position = textField.position(from: textField.beginningOfDocument, offset: newIndex + 1) else { return false }
                textField.text = txt
                
                textField.selectedTextRange = textField.textRange(from: position, to: position)
            } else if string.isEmpty {
                guard let selectedRange = textField.selectedTextRange else { return false }
                let index = textField.offset(from: textField.beginningOfDocument, to: selectedRange.start) - 1
                let stringIndex = txt.index(txt.startIndex, offsetBy: index)
                
                //перенос курсора
                guard let position = textField.position(from: textField.beginningOfDocument, offset: index) else { return false }
                
                switch index {
                case 15:
                    textField.selectedTextRange = textField.textRange(from: position, to: position)
                case 12:
                    textField.selectedTextRange = textField.textRange(from: position, to: position)
                case 8:
                    guard let positionNew = textField.position(from: textField.beginningOfDocument, offset: index - 1) else { return false }
                    textField.selectedTextRange = textField.textRange(from: positionNew, to: positionNew)
                case 7:
                    textField.selectedTextRange = textField.textRange(from: position, to: position)
                case 3:
                    guard let positionNew = textField.position(from: textField.beginningOfDocument, offset: index - 1) else { return false }
                    textField.selectedTextRange = textField.textRange(from: positionNew, to: positionNew)
                case 2:
                    textField.selectedTextRange = textField.textRange(from: position, to: position)
                case 1:
                    return false
                case 0:
                    return false
                default:
                    txt.remove(at: stringIndex)
                    txt.insert("*", at: stringIndex)
                    textField.text = txt
                    textField.selectedTextRange = textField.textRange(from: position, to: position)
                }
            }
        }
        
        return false
    }
    
}

extension BuyerTableCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.accessibilityIdentifier == "0" {
            
            return applyPhoneNumberMask(textField: textField, replacementString: string)
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard let index = Int(textField.accessibilityIdentifier ?? "") else { return }
        guard let stackViewLitle = stackView.arrangedSubviews[index] as? UIStackView else { return }
        stackViewLitle.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.98, alpha: 1)
        
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
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let index = Int(textField.accessibilityIdentifier ?? "") else { return }
        
        if let text = textField.text, !text.isEmpty {
        } else {
            if stackView.arrangedSubviews.indices.contains(index) {
                guard let verticalStack = stackView.arrangedSubviews[index] as? UIStackView else { return }
                
                guard let label = verticalStack.arrangedSubviews[0] as? UILabel else { return }
                
                verticalStack.removeArrangedSubview(label)
                label.removeFromSuperview()
            }
        }
        
        //проверка на заполнение
        if let text = textField.text {
            switch index {
            case 0:
                guard let stackView = stackView.arrangedSubviews[index] as? UIStackView else { return }
                if delegate?.correctPhoneNumber(string: text) == false {
                    let color = #colorLiteral(red: 0.9450980392, green: 0.4352941176, blue: 0.4156862745, alpha: 0.8545386905)
                    stackView.backgroundColor = color
                } else {
                    stackView.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.98, alpha: 1)
                }
            case 1:
                guard let stackView = stackView.arrangedSubviews[index] as? UIStackView else { return }
                if delegate?.correctEmail(string: text) == false {
                    let color = #colorLiteral(red: 0.9450980392, green: 0.4352941176, blue: 0.4156862745, alpha: 0.8545386905)
                    stackView.backgroundColor = color
                } else {
                    stackView.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.98, alpha: 1)
                }
            default:
                break
            }
        }
    }
}
