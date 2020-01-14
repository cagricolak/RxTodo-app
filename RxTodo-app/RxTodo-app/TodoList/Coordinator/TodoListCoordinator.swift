//
//  TodoListCoordinator.swift
//  RxTodo-app
//
//  Created by Çağrı ÇOLAK on 10.01.2020.
//  Copyright © 2020 MW. All rights reserved.
//

import UIKit

class TodoListCoordinator: BaseCoordinator {
    var childControllers = [BaseCoordinator]()
    var navigationController: UINavigationController
    
    init(navigationController:UINavigationController) {
        self.navigationController = navigationController
    }
    
    func navigateTo()  {
        let todoListScreen = TodoListVC.instantiate()
        todoListScreen.todoListCoordinator = self
        navigationController.pushViewController(todoListScreen, animated: false)
    }
    
}
