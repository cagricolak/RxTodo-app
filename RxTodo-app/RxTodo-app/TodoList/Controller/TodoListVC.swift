//
//  TodoListVC.swift
//  RxTodo-app
//
//  Created by Çağrı ÇOLAK on 10.01.2020.
//  Copyright © 2020 MW. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit
import RxAlertViewable
import SDCAlertView

class TodoListVC: UIViewController, Storyboarded,RxAlertViewable {
    weak var todoListCoordinator: TodoListCoordinator?
    private var todoListVM = TodoListVM()
    private let disposeBag = DisposeBag()
    private let cellIdentifier = "TodoListCell"

    lazy var todolistTableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureSearchTableView()
        bindVM()
    }
    
    private func bindVM() {
        todoListVM.getAllTodoList()
            .bind(to: todolistTableView.rx.items(cellIdentifier: cellIdentifier, cellType: TodoListCell.self)) {_, model, cell in
                cell.setup = model
                cell.checkbox.rx.controlEvent(.valueChanged).bind {[unowned self] in
                    self.todoListVM.changeTodoState(state: cell.checkbox!.checkState, todoID: model.id)
                    }.disposed(by: self.disposeBag)
            }.disposed(by: disposeBag)
        todoListVM.alert.bind(to: rx.alert).disposed(by: disposeBag)
        
        todolistTableView.rx.modelSelected(Todo.self).bind {[weak self] model in
            let todoDetailCoordinator = TodoDetailCoordinator(navigationController: (self?.navigationController)!)
            todoDetailCoordinator.navigateTo(with: model)
            }.disposed(by: disposeBag)
    }
    
    private func configureUI() {
        self.title = "Todo List"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewTodo))
    }
    
    @objc private func addNewTodo() {
        let newTodoController = self.todoListVM.createNewTodoController()
        newTodoController.present()
    }
    
    private func configureSearchTableView() {
        self.view.addSubview(todolistTableView)
        self.todolistTableView.rowHeight = 60
        self.todolistTableView.estimatedRowHeight = UITableView.automaticDimension
        
        self.todolistTableView.register(UINib(nibName: "TodoListCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        todolistTableView.translatesAutoresizingMaskIntoConstraints = false
        
        todolistTableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 30, left: 0, bottom: 0, right: 0))
        }
    }
}


