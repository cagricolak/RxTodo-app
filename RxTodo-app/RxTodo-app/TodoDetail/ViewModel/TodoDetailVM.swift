//
//  TodoDetailVM.swift
//  RxTodo-app
//
//  Created by Çağrı ÇOLAK on 11.01.2020.
//  Copyright © 2020 MW. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxAlertViewable
import M13Checkbox

class TodoDetailVM {
    var alert = PublishSubject<RxAlert>()
    private lazy var message = ""
    private let disposeBag = DisposeBag()
    let todoListVM = TodoListVM()
    
    private var todoData:Todo?
    
    init(todoData:Todo) {
        self.todoData = todoData
    }
    
    func todoTitle() -> String {
        return self.todoData?.title ?? ""
    }
    
    func todoID() -> Int {
        return self.todoData?.id ?? 0
    }
    
    func todoCompleted() -> Bool {
        return self.todoData?.completed ?? false
    }
    
    func updateTodo(title:String) {
        self.updateTodo(todoID: self.todoID(), title: title).asObservable().subscribe(onNext: {[weak self] (todoModel) in
            switch todoModel {
            case true:
                self?.alert.onNextTip("Changes are saved")
            case false:
                self?.alert.onNextError("Failed to save changes")
            }
        }).disposed(by: disposeBag)
    }
    
    func deleteTodo() {
        self.deleteTodo(todoID: self.todoID()).asObservable().subscribe(onNext: {[weak self] (todoModel) in
            switch todoModel {
            case true:
                self?.alert.onNextTip("Deletion succeed")
            case false:
                self?.alert.onNextError("An error has occurred, failed.")
            }
        }).disposed(by: disposeBag)
    }
    
    private func updateTodo(todoID:Int,title:String)-> Observable<Bool>{
        var apiController = APIController()
        let serviceController = ServiceController()
        let request = apiController.updateTodoTitleRequest(with: todoID, title: title)
        return serviceController.createUpdateDeleteTodo(with: request)
    }
    
    private func deleteTodo(todoID:Int)-> Observable<Bool>{
        var apiController = APIController()
        let serviceController = ServiceController()
        let request = apiController.deleteTodoRequest(with: todoID)
        return serviceController.createUpdateDeleteTodo(with: request)
    }
    
    func changeTodoState(checkState:M13Checkbox.CheckState,todoID:Int?) {
        todoListVM.changeTodoState(state: checkState, todoID: todoID ?? 0)
    }
}
