//
//  TodoDetailCoordinator.swift
//  RxTodo-app
//
//  Created by Çağrı ÇOLAK on 11.01.2020.
//  Copyright © 2020 MW. All rights reserved.
//

import UIKit

class TodoDetailCoordinator: BaseCoordinator {
    var childControllers = [BaseCoordinator]()
    var navigationController: UINavigationController
    
    init(navigationController:UINavigationController) {
        self.navigationController = navigationController
    }
    
    func navigateTo(with data:Todo)  {
        let todoDetailScreen = TodoDetailVC.instantiate()
        todoDetailScreen.todoDetailCoordinator = self
        todoDetailScreen.todoModel = data
        navigationController.pushViewController(todoDetailScreen, animated: true)
    }
    
}
