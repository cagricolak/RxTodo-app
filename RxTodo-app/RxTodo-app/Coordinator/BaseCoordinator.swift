//
//  BaseCoordinator.swift
//  RxTodo-app
//
//  Created by Çağrı ÇOLAK on 10.01.2020.
//  Copyright © 2020 MW. All rights reserved.
//

import UIKit

protocol BaseCoordinator {
    var childControllers: [BaseCoordinator] {get set}
    var navigationController: UINavigationController {get set}
}
