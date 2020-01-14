//
//  TodoListCell.swift
//  RxTodo-app
//
//  Created by Çağrı ÇOLAK on 11.01.2020.
//  Copyright © 2020 MW. All rights reserved.
//

import UIKit
import M13Checkbox
import SnapKit
import RxCocoa
import RxSwift
import RxAlertViewable

class TodoListCell: UITableViewCell, RxAlertViewable {
    let alert = PublishSubject<RxActionSheet>()
    let todoListVM = TodoListVM()
    let disposeBag = DisposeBag()
    var checkbox:M13Checkbox!
    var setup:Todo!{
        didSet {
            self.textLabel?.text = self.setup.title
            self.checkbox.stateChangeAnimation = .fill
            
            if let completed = self.setup.completed, completed {
                self.checkbox.setCheckState(.checked, animated: true)
            }else {
                self.checkbox.setCheckState(.unchecked, animated: true)
            }
            
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureCell()
    }

    private func configureCell() {
        checkbox = M13Checkbox(frame: CGRect.zero)
        self.addSubview(checkbox)
        checkbox.translatesAutoresizingMaskIntoConstraints = false
        checkbox.boxType = .circle
        checkbox.markType = .radio
        
        checkbox.snp.makeConstraints { (make) in
            make.leadingMargin.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
            make.width.equalTo(20)
            make.height.equalTo(20)
        }
        
        self.textLabel?.numberOfLines = 0
        self.textLabel?.snp.makeConstraints({ (make) in
            make.leadingMargin.equalTo(60)
            make.trailingMargin.equalTo(20)
            make.centerY.equalToSuperview()
        })
        
    }
    
    
}
