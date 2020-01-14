//
//  ServiceController.swift
//  RxTodo-app
//
//  Created by Çağrı ÇOLAK on 10.01.2020.
//  Copyright © 2020 MW. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire
import AlamofireObjectMapper

struct ServiceController {
    func getAllTodo(with requestObject:URLRequest) -> Observable<[Todo]> {
        return Observable<[Todo]>.create { observer in
            Alamofire.request(requestObject).responseArray(completionHandler: { (response:DataResponse<[Todo]>) in
                guard let responseData = response.result.value else {
                    fatalError("responseModel failed")
                }
                do {
                    observer.onNext(responseData)
                    observer.onCompleted()
                }
            })
            return Disposables.create()
        }
    }
    
    func createUpdateDeleteTodo(with requestObject:URLRequest) -> Observable<Bool> {
        return Observable<Bool>.create { observer in
            Alamofire.request(requestObject).responseJSON(completionHandler: { response in
                guard let httpResponseCode = response.response?.statusCode else {
                    fatalError("httpResponseCode failed")
                }
                do {
                    switch httpResponseCode {
                    case 200, 201:
                        observer.onNext(true)
                        observer.onCompleted()
                    default:
                        observer.onNext(false)
                        observer.onCompleted()
                    }
                }
            })
            return Disposables.create()
        }
    }
}
