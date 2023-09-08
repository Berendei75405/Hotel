//
//  BookingViewModel.swift
//  Hotel
//
//  Created by Новгородцев Никита on 02.09.2023.
//

import Foundation
import Combine

protocol BookingViewModelProtocol: AnyObject {
    var bookingModel: BookingModel? { get set }
    var updateTableState: PassthroughSubject<TableState, Never> {get set}
    var tourist: [TouristCorrect] {get set}
    var cellTitles: [String] {get}
    var buttonStates: [Int : Bool] {get set}
    func fetchBookingModel()
    func popToRoot()
    func validateNumberPhone(string: String) -> Bool
    func validateEmail(string: String) -> Bool
    func returnCellHeight(index: Int) -> CGFloat
    func changeHeight(index: Int, heightNew: CGFloat)
    func correctTouristCell(indexCell: Int, indexTextField: Int, string: String) -> Bool
    func addTourist() -> [[Int]]?
    func addTouristInfo(indexCell: Int, indexTextField: Int, string: String)
    func totalPrice() -> Int
    func chechAllTextFields() -> ([[Int]], [Int])
    func showOrderModule()
}

final class BookingViewModel: BookingViewModelProtocol {
    var coordinator: MainCoordinatorProtocol!
    private let networkManager = NetworkManager.shared
    
    deinit {
        print("BookingViewModel")
    }
    
    var bookingModel: BookingModel?
    var updateTableState = PassthroughSubject<TableState, Never>()
    var buttonStates: [Int: Bool] = [3: false, 4: false]
    
    private var phoneNumber = ""
    private var email = ""
    //Массив туристов 
    var tourist = [TouristCorrect(name: "", surname: "", wasBorn: "", nationality: "", numberInternationalPassport: "", validityInternationalPassport: "")]
    
    var cellHeights: [CGFloat] = [170, 320, 252, 436, 64, 162]
    var cellTitles = ["Первый турист", "Второй турист", "Третий турист", "Четвертый турист", "Пятый турист", "Шестой турист", "Седьмой турист", "Восьмой турист", "Девятый турист", "Десятый турист"]
    
    //MARK: - fetchBookingModel
    func fetchBookingModel() {
        networkManager.fetchBookingModel { [weak self] result in
            switch result {
            case .success(let model):
                self?.bookingModel = model
                self?.updateTableState.send(.success)
            case .failure(let error):
                print(error)
                self?.updateTableState.send(.failure)
            }
        }
    }
    
    //MARK: - popToRoot()
    func popToRoot() {
        coordinator.goBack()
    }
    
    //MARK: - validateNumberPhone
    func validateNumberPhone(string: String) -> Bool {
        let bool = (!string.contains("*") && !string.isEmpty)
        if bool {
            phoneNumber = string
        } else {
            phoneNumber = ""
        }
        return bool
    }
    
    //MARK: - validateEmail
    func validateEmail(string: String) -> Bool {
        let bool = string.isEmail()
        if bool {
            email = string
        } else {
            email = ""
        }
        
        return bool
    }
    
    //MARK: - returnCellHeight
    func returnCellHeight(index: Int) -> CGFloat {
        return cellHeights.indices.contains(index) ? cellHeights[index] : 0
    }
    
    //MARK: - changeHeight
    func changeHeight(index: Int, heightNew: CGFloat) {
        if cellHeights.indices.contains(index) {
            cellHeights[index] = heightNew
        }
    }
    
    //MARK: - correctTouristCell
    func correctTouristCell(indexCell: Int, indexTextField: Int, string: String) -> Bool {
        return !string.isEmpty
    }
    
    //MARK: - addTourist
    func addTourist() -> [[Int]]?  {
        let check = checkTextFields()
        if check.isEmpty {
            tourist.append(TouristCorrect(name: "", surname: "", wasBorn: "", nationality: "", numberInternationalPassport: "", validityInternationalPassport: ""))
            cellHeights.insert(436, at: cellHeights.count - 2)
            
            return nil
        } else {
            return check
        }
    }
    
    //MARK: - checkTextFields
    private func checkTextFields() -> [[Int]] {
        var indexCell = 0
        //первое число это какая ячейка по счету, вторая это поле в котором проблема
        var cellsbroken = [[Int]]()
        
        //проверка заполнены ли поля
        for item in 0..<tourist.count {
            if tourist[item].name.isEmpty {
                cellsbroken.append([indexCell, 0])
            }
            
            if tourist[item].surname.isEmpty {
                cellsbroken.append([indexCell, 1])
            }
            
            if tourist[item].wasBorn.isEmpty {
                cellsbroken.append([indexCell, 2])
            }
            
            if tourist[item].nationality.isEmpty {
                cellsbroken.append([indexCell, 3])
            }
            
            if tourist[item].numberInternationalPassport.isEmpty {
                cellsbroken.append([indexCell, 4])
            }
            
            if tourist[item].validityInternationalPassport.isEmpty {
                cellsbroken.append([indexCell, 5])
            }
            
            indexCell += 1
        }
        
        return cellsbroken
    }
    
    //MARK: - addTouristInfo
    func addTouristInfo(indexCell: Int, indexTextField: Int, string: String) {
        switch indexTextField {
        case .zero:
            tourist[indexCell].name = string
        case 1:
            tourist[indexCell].surname = string
        case 2:
            tourist[indexCell].wasBorn = string
        case 3:
            tourist[indexCell].nationality = string
        case 4:
            tourist[indexCell].numberInternationalPassport = string
        case 5:
            tourist[indexCell].validityInternationalPassport = string
        default:
            break
        }
    }
    
    //MARK: - totalPrice
    func totalPrice() -> Int {
        return (bookingModel?.fuelCharge ?? 0) + (bookingModel?.tourPrice ?? 0) + (bookingModel?.serviceCharge ?? 0) 
    }
    
    //MARK: - chechAllTextFields
    func chechAllTextFields() -> ([[Int]], [Int]) {
        var indexCell = 0
        //первое число это какая ячейка по счету, вторая это поле в котором проблема
        var cellsbroken = [[Int]]()
        var phoneAndEmail = [Int]()
        
        //проверка заполнены ли поля
        for item in 0..<tourist.count {
            if tourist[item].name.isEmpty {
                cellsbroken.append([indexCell, 0])
            }
            
            if tourist[item].surname.isEmpty {
                cellsbroken.append([indexCell, 1])
            }
            
            if tourist[item].wasBorn.isEmpty {
                cellsbroken.append([indexCell, 2])
            }
            
            if tourist[item].nationality.isEmpty {
                cellsbroken.append([indexCell, 3])
            }
            
            if tourist[item].numberInternationalPassport.isEmpty {
                cellsbroken.append([indexCell, 4])
            }
            
            if tourist[item].validityInternationalPassport.isEmpty {
                cellsbroken.append([indexCell, 5])
            }
            
            indexCell += 1
        }
        if validateNumberPhone(string: phoneNumber) == false {
            phoneAndEmail.append(0)
        }
        if validateEmail(string: email) == false {
            phoneAndEmail.append(1)
        }
        
        return (cellsbroken, phoneAndEmail)
    }
    
    //MARK: - showOrderModule
    func showOrderModule() {
        coordinator.showOrderModule()
    }
}

