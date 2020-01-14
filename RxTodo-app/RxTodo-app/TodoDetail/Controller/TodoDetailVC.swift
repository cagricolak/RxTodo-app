//
//  TodoDetailVC.swift
//  RxTodo-app
//
//  Created by Çağrı ÇOLAK on 11.01.2020.
//  Copyright © 2020 MW. All rights reserved.
//

import UIKit
import RxSwift
import SnapKit
import M13Checkbox
import RxCocoa
import RxAlertViewable
import SDCAlertView


class TodoDetailVC: UIViewController,Storyboarded,RxAlertViewable {
    
    weak var todoDetailCoordinator: TodoDetailCoordinator?
    var todoModel:Todo?
    var todoTitle = UITextField(frame: .zero)
    var todoStatus = M13Checkbox(frame: .zero)
    var stackView = UIStackView(frame: .zero)
    
    var updateButton:UIBarButtonItem!
    var deleteButton:UIBarButtonItem!
    var doneButton:UIBarButtonItem!
    var cancelButton:UIBarButtonItem!
    var textFieldTempData = ""
    
    var disposeBag = DisposeBag()
    var todoDetailVM:TodoDetailVM!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindUI()
        
    }
    
    @objc private func deleteTodo() {
        let deleteTitle = NSAttributedString(string: "Delete operation", attributes: [NSAttributedString.Key.foregroundColor: UIColor.orange, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 11)])
        
        let deleteMessage = NSAttributedString(string: "Do you confirm the deletion?", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .regular)])
        
        let alert = AlertController(attributedTitle: deleteTitle, attributedMessage: deleteMessage, preferredStyle: .actionSheet)
        alert.visualStyle.normalTextColor = .red
        
        alert.addAction(AlertAction(title: "Delete", style: .normal, handler: { [weak self] _ in
            // server rquest
            self?.todoDetailVM.deleteTodo()
            self?.navigationItem.rightBarButtonItems = self?.updateNavigationItems(actionType: .delete)
        }))
        alert.present()
    }
    
    @objc private func changesDone() {
        navigationItem.rightBarButtonItems = updateNavigationItems(actionType: .done)
        
        self.todoDetailVM.updateTodo(title: self.todoTitle.text ?? "")
        
    }
}







extension TodoDetailVC {
    
    private enum NavBarButtonType {
        case update
        case delete
        case cancel
        case done
        case none
    }
    
    private func bindUI() {
        guard let todoModelData = todoModel else { return }
        todoDetailVM = TodoDetailVM(todoData: todoModelData)
        todoTitle.text = todoDetailVM.todoTitle()
        if todoDetailVM.todoCompleted() {
            todoStatus.checkState = .checked
        }else {
            todoStatus.checkState = .unchecked
        }
        
        self.todoStatus.rx.controlEvent(.valueChanged).bind {[unowned self] in
            self.todoDetailVM.changeTodoState(checkState: self.todoStatus.checkState, todoID: self.todoDetailVM.todoID())
            }.disposed(by: self.disposeBag)
        self.todoDetailVM.alert.bind(to: rx.alert).disposed(by: disposeBag)
        self.todoDetailVM.todoListVM.alert.bind(to: rx.alert).disposed(by: disposeBag)
    }
    
    private func configureUI() {
        navigationItem.rightBarButtonItems = updateNavigationItems(actionType: .none)
        configureTodoCheckbox()
    }
    
    private func updateNavigationItems(actionType:NavBarButtonType)-> [UIBarButtonItem]?{
        switch actionType {
        case .update:
            changeTextFieldState(actionType: .update)
            navigationItem.rightBarButtonItems = nil
            cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelEdit))
            doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(changesDone))
            return [cancelButton, doneButton]
        case .cancel, .done ,.delete, .none:
            changeTextFieldState(actionType: .cancel)
            navigationItem.rightBarButtonItems = nil
            deleteButton = UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(deleteTodo))
            updateButton = UIBarButtonItem(title: "Update", style: .plain, target: self, action: #selector(updateTodo))
            return [deleteButton, updateButton]
        }
    }
    
    @objc private func cancelEdit() {
        navigationItem.rightBarButtonItems = updateNavigationItems(actionType: .cancel)
        todoTitle.text = textFieldTempData
    }
    
    @objc private func updateTodo() {
        navigationItem.rightBarButtonItems = updateNavigationItems(actionType: .update)
        textFieldTempData = todoTitle.text ?? ""
    }
    
    private func changeTextFieldState(actionType:NavBarButtonType) {
        switch actionType {
        case .update:
            todoTitle.isUserInteractionEnabled = true
            todoTitle.borderStyle = .roundedRect
        default:
            todoTitle.isUserInteractionEnabled = false
            todoTitle.borderStyle = .none
        }
    }
    
    private func configureTodoCheckbox() {
        self.view.addSubview(todoStatus)
        todoStatus.translatesAutoresizingMaskIntoConstraints = false
        todoStatus.stateChangeAnimation = .fill
        todoStatus.boxType = .circle
        todoStatus.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().inset(20)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).inset(50)
            make.width.equalTo(20)
            make.height.equalTo(20)
        }
        
        configureTodoTitle()
    }
    
    private func configureTodoTitle() {
        self.view.addSubview(todoTitle)
        todoTitle.translatesAutoresizingMaskIntoConstraints = false
        todoTitle.isUserInteractionEnabled = false
        todoTitle.borderStyle = .none
        todoTitle.adjustsFontSizeToFitWidth = true
        todoTitle.snp.makeConstraints { (make) in
            make.leading.equalTo(todoStatus.snp.leadingMargin).inset(30)
            make.trailing.equalToSuperview().inset(30)
            make.centerY.equalTo(todoStatus.snp.centerY)
        }
    }
}
