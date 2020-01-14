//
//  TodoListVM.swift
//  RxTodo-app
//
//  Created by Çağrı ÇOLAK on 10.01.2020.
//  Copyright © 2020 MW. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxAlertViewable
import M13Checkbox
import SDCAlertView

typealias TodoState = M13Checkbox.CheckState
typealias TodoTitle = String
typealias TodoID = Int
typealias CheckState = Bool
typealias NewTodoController = AlertController

class TodoListVM {
    var alert = PublishSubject<RxAlert>()
    private lazy var message = ""
    private let disposeBag = DisposeBag()
    
    func getAllTodoList() -> Observable<[Todo]>{
        var apiController = APIController()
        let serviceController = ServiceController()
        let request = apiController.allTodoListRequest()
        return serviceController.getAllTodo(with: request)
    }
    
    func changeTodoState(state:TodoState,todoID:TodoID?) {
        switch state {
        case .checked:
            message = "Mark completed"
            if let todoID = todoID {
                self.changeTodoStatu(todoID: todoID, statu: true).asObservable().subscribe(onNext: {[weak self] (todoModel) in
                    switch todoModel {
                    case true:
                        self?.alert.onNextTip(self!.message)
                    case false:
                        self?.alert.onNextError("unknown TODO")
                    }
                }).disposed(by: disposeBag)
            }
        case .unchecked:
             message = "Mark uncompleted"
             if let todoID = todoID {
                self.changeTodoStatu(todoID: todoID, statu: true).asObservable().subscribe(onNext: {[weak self] (todoModel) in
                    switch todoModel {
                    case true:
                        self?.alert.onNextTip(self!.message)
                    case false:
                        self?.alert.onNextError("unknown TODO")
                    }
                }).disposed(by: disposeBag)
             }
        default:
           break
        }
    }
    
    private func createTodo(title:TodoTitle) {
            message = "New todo created"
                self.createNewTodo(title: title).asObservable().subscribe(onNext: {[weak self] (todoResponse) in
                    switch todoResponse {
                    case true:
                        self?.alert.onNextTip(self!.message)
                    case false:
                        self?.alert.onNextError("New todo creation has failed")
                    }
                }).disposed(by: disposeBag)
    }
    
    private func createNewTodo(title:TodoTitle)-> Observable<Bool>{
        var apiController = APIController()
        let serviceController = ServiceController()
        let request = apiController.newTodoRequest(title: title)
        return serviceController.createUpdateDeleteTodo(with: request)
    }
    
    private func changeTodoStatu(todoID:TodoID,statu:CheckState)-> Observable<Bool>{
        var apiController = APIController()
        let serviceController = ServiceController()
        let request = apiController.changeTodoStateRequest(todoID: todoID, statu: statu)
        return serviceController.createUpdateDeleteTodo(with: request)
    }
    
    func createNewTodoController() -> NewTodoController{
        let addTodoTitle = NSAttributedString(string: "Add new todo", attributes: [NSAttributedString.Key.foregroundColor: UIColor.orange, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 11)])
        let cancelTitle = NSAttributedString(string: "Cancel", attributes: [NSAttributedString.Key.foregroundColor: UIColor.blue, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15)])
        let addTodoMessage = NSAttributedString(string: "Getting started is the end.", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .regular)])
        let alert = NewTodoController(attributedTitle: addTodoTitle, attributedMessage: addTodoMessage, preferredStyle: .alert)
        alert.visualStyle.normalTextColor = .red
        alert.addTextField()
        alert.addAction(AlertAction(title: "Add", style: .normal, handler: { [weak self] _ in
            if let todoTitle = alert.textFields?.first?.text, todoTitle.count > 3 {
                self?.createTodo(title: todoTitle)
            }
        }))
        alert.addAction(AlertAction(attributedTitle: cancelTitle, style: .destructive))
        return alert
    }
    
}
