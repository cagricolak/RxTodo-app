//
//  TodoModel.swift
//  RxTodo-app
//
//  Created by Çağrı ÇOLAK on 10.01.2020.
//  Copyright © 2020 MW. All rights reserved.
//

import Foundation
import ObjectMapper


// MARK: - Todo
struct Todo: Mappable {
    var id: Int?
    var title: String?
    var completed: Bool?
    
    init?(map: Map) {
        
    }
    
    // Mappable
    mutating func mapping(map: Map) {
        id <- map["id"]
        title <- map["title"]
        completed <- map["completed"]
    }
}

struct TodoStatu: Mappable {
    var id: Int?
    var completed: String?
    
    init?(map: Map) {
        
    }
    
    // Mappable
    mutating func mapping(map: Map) {
        id <- map["id"]
        completed <- map["completed"]
    }
}

