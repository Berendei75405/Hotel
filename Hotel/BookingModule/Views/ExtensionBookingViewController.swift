//
//  ExtensionBookingViewController.swift
//  Hotel
//
//  Created by Новгородцев Никита on 03.09.2023.
//

import UIKit

extension BookingViewController {
    //MARK: - setBackButton
    func setBackButton() {
        let viewTitle = UIView(frame: .zero)
        viewTitle.frame = CGRect(x: .zero,
                                 y: .zero,
                                 width: view.frame.width,
                                 height: 44)
        viewTitle.clipsToBounds = true
        
        let backButton = UIButton()
        backButton.frame = CGRect(x: .zero,
                                  y: .zero,
                                  width: 44,
                                  height: 44)
        backButton.setImage(UIImage(named: "back"), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonTap), for: .touchUpInside)
        
        let titleLabel = UILabel(frame: .zero)
        titleLabel.frame = CGRect(x: 0,
                                      y: .zero,
                                      width: viewTitle.frame.width - 44,
                                      height: 44)
        titleLabel.font = .init(name: "SFProDisplay-Medium", size: 18)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .black
        titleLabel.text = "Бронирование"
        
        viewTitle.addSubview(backButton)
        viewTitle.addSubview(titleLabel)
        self.navigationItem.titleView = viewTitle
    }
    
    @objc func backButtonTap() {
        tabBar?.tabBar.isHidden = true
        tabBar?.button.setTitle("К выбору номера", for: .normal)
        viewModel.popToRoot()
    }
}
