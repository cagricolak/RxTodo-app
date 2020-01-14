//
//  APIController.swift
//  RxTodo-app
//
//  Created by Çağrı ÇOLAK on 10.01.2020.
//  Copyright © 2020 MW. All rights reserved.
//
import Foundation

typealias ApiSecretKey = String
typealias ServiceBaseURL = String
typealias SearchInputText = String
typealias PlaceID = String
typealias photoRefID = String

enum APIPath:String{
    case todoList = "/cagricolak/todoDummyRepo/todos"
    case placeDetail = "/maps/api/place/details/json"
    case placePhoto = "/maps/api/place/photo"
}

struct APIController {
    private var urlComponents = URLComponents()
    
    init() {
        self.urlComponents.scheme = "http"
        self.urlComponents.host = "my-json-server.typicode.com"
    }
    
    mutating func allTodoListRequest() -> URLRequest {
        self.urlComponents.path = APIPath.todoList.rawValue
        guard let requestURL = urlComponents.url else { fatalError("request url can't created")}
        var urlRequest = URLRequest(url: requestURL)
        urlRequest.httpMethod = "GET"
        return urlRequest
    }
    
    mutating func newTodoRequest(title:String) -> URLRequest {
        self.urlComponents.path = APIPath.todoList.rawValue
        let newTodoTitle = URLQueryItem(name: "title", value: title)
        let newTodoCompleted = URLQueryItem(name: "completed", value: "false")
        urlComponents.queryItems = [newTodoTitle,newTodoCompleted]
        guard let requestURL = urlComponents.url else { fatalError("request url can't created")}
        var urlRequest = URLRequest(url: requestURL)
        urlRequest.httpMethod = "POST"
        return urlRequest
    }
    
    mutating func changeTodoStateRequest(todoID:Int, statu:Bool) -> URLRequest {
        let todoID = "\(todoID)"
        self.urlComponents.path = "\(APIPath.todoList.rawValue)/".appending(todoID)
        let completedQuery = URLQueryItem(name: "completed", value: "\(statu)")
        urlComponents.queryItems = [completedQuery]
        guard let requestURL = urlComponents.url else { fatalError("request url can't created")}
        var urlRequest = URLRequest(url: requestURL)
        urlRequest.httpMethod = "PUT"
        return urlRequest
    }
    
    mutating func updateTodoTitleRequest(with todoID:Int, title:String) -> URLRequest {
        let todoID = "\(todoID)"
        self.urlComponents.path = "\(APIPath.todoList.rawValue)/".appending(todoID)
        let todoTitleQuery = URLQueryItem(name: "title", value: title)
        urlComponents.queryItems = [todoTitleQuery]
        guard let requestURL = urlComponents.url else { fatalError("request url can't created")}
        var urlRequest = URLRequest(url: requestURL)
        urlRequest.httpMethod = "PUT"
        return urlRequest
    }
    
    mutating func deleteTodoRequest(with todoID:Int) -> URLRequest {
        let todoID = "\(todoID)"
        self.urlComponents.path = "\(APIPath.todoList.rawValue)/".appending(todoID)
        guard let requestURL = urlComponents.url else { fatalError("request url can't created")}
        var urlRequest = URLRequest(url: requestURL)
        urlRequest.httpMethod = "DELETE"
        return urlRequest
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
//    mutating func getPlaceDetail(with placeID:PlaceID) -> URLRequest {
//        
//        self.urlComponents.path = APIPath.placeDetail.rawValue
//        
//        let inputQuery = URLQueryItem(name: "place_id", value: placeID)
//        let inputType = URLQueryItem(name: "inputtype", value: "textquery")
//        let scretKey = URLQueryItem(name: "key", value: secretKey)
//        let fields = URLQueryItem(name: "fields", value: "name,formatted_address,photo")
//        
//        urlComponents.queryItems = [inputQuery,inputType,scretKey,fields]
//        
//        guard let requestURL = urlComponents.url else { fatalError("request url can't created") }
//        
//        var urlRequest = URLRequest(url: requestURL)
//        urlRequest.httpMethod = "GET"
//        
//        return urlRequest
//    }
//    
//    mutating func getPlaceImage(with photoRef:photoRefID) -> URLRequest {
//        
//        self.urlComponents.path = APIPath.placePhoto.rawValue
//        
//        let maxWidth = URLQueryItem(name: "maxwidth", value: "300")
//        let photoRef = URLQueryItem(name: "photoreference", value: photoRef)
//        let scretKey = URLQueryItem(name: "key", value: secretKey)
//        
//        urlComponents.queryItems = [maxWidth,photoRef,scretKey]
//        
//        guard let requestURL = urlComponents.url else { fatalError("request url can't created") }
//        
//        var urlRequest = URLRequest(url: requestURL)
//        urlRequest.httpMethod = "GET"
//        
//        return urlRequest
//    }
    
}

