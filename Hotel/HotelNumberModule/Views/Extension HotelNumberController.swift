//
//  Extension HotelNumberController.swift
//  Hotel
//
//  Created by Новгородцев Никита on 01.09.2023.
//

import UIKit

extension HotelNumberViewController {
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
        
        let selectLabel = UILabel(frame: .zero)
        selectLabel.frame = CGRect(x: 44,
                                      y: .zero,
                                      width: viewTitle.frame.width - backButton.frame.width - 44,
                                      height: 44)
        selectLabel.font = .init(name: "SFProDisplay-Medium", size: 18)
        selectLabel.textAlignment = .center
        selectLabel.textColor = .black
        selectLabel.text = select
        
        viewTitle.addSubview(backButton)
        viewTitle.addSubview(selectLabel)
        self.navigationItem.titleView = viewTitle
    }
    
    @objc func backButtonTap() {
        viewModel.popToRoot()
    }
}
