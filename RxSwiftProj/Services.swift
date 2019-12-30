//
//  Services.swift
//  RxSwiftProj
//
//  Created by administrator on 12/23/19.
//  Copyright © 2019 Vision. All rights reserved.
//

import UIKit
import Alamofire
import RxAlamofire
import RxSwift
import RxCocoa

let services = Services.serviceShared

class Services: NSObject {
    
    static var serviceShared = Services()
    let manager = SessionManager.default

    func requestFromAPI(url: String){
        _ = RxAlamofire.requestJSON(.get, url).subscribe(onNext: { [weak self] (r, json) in
            print(json)
        })
        
        _ = RxAlamofire.request(.get, url, parameters: nil, headers: nil).responseJSON().subscribe(onNext: { (res) in
            print(res)
        })
        let result = manager.rx.request(.get, url).validate(statusCode: 200..<400).flatMap { (request) -> Observable<(String?, RxProgress)> in
            let stringPart = request.rx
                .string()
                .map { d -> String? in d }
                .startWith(nil as String?)
            let progressPart = request.rx.progress()
            return Observable.combineLatest(stringPart, progressPart) { ($0, $1) }
        }.observeOn(MainScheduler.instance).subscribe{
            print($0)
        }
        _ = manager.rx.request(.get, url).validate(statusCode: 200..<400).json().observeOn(MainScheduler.instance).subscribe{
            print($0)
        }
//        print("result: \(resultJson)")
//            .validate(contentType: )
        
    }
    
    
    func request<T: Codable> (_ urlConvertible: URLRequestConvertible, url: String) -> Observable<T> {
        //Create an RxSwift observable, which will be the one to call the request when subscribed to
        return Observable<T>.create { observer in
            //Trigger the HttpRequest using AlamoFire (AF)
//            let request = Alamofire.request(urlConvertible).responseJSON { (response) in
//                //Check the result from Alamofire's response and check if it's a success or a failure
//                switch response.result {
//                case .success(let value):
//                    //Everything is fine, return the value in onNext
////                    observer.onNext(value)
//                    observer.onCompleted()
//                case .failure(let error):
//                    //Something went wrong, switch on the status code and return the error
////                    switch response.response?.statusCode {
////                    case 403:
////                        observer.onError(ApiError.forbidden)
////                    case 404:
////                        observer.onError(ApiError.notFound)
////                    case 409:
////                        observer.onError(ApiError.conflict)
////                    case 500:
////                        observer.onError(ApiError.internalServerError)
////                    default:
//                        observer.onError(error)
////                    }
//                }
            let request = self.manager.rx.request(.get, url).validate(statusCode: 200..<400).json().observeOn(MainScheduler.instance).subscribe{
//                observer($0.element)
                    print($0)
                }
//            }
            
            //Finally, we return a disposable to stop the request
            return Disposables.create {
                request.dispose()
            }
        }
    }
    
}
