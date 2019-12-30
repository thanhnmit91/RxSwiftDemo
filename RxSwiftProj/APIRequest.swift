//
//  APIRequest.swift
//  RxSwiftProj
//
//  Created by administrator on 12/20/19.
//  Copyright © 2019 Vision. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

public enum RequestType: String {
    case GET, POST, PUT,DELETE
}

class APIRequest {
    let baseURL = URL(string: "https://api.printful.com/countries")!
    var method = RequestType.GET
    var parameters = [String: String]()
    
    func request(with baseURL: URL) -> URLRequest {
       var request = URLRequest(url: baseURL)
        request.httpMethod = method.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
    
}

class APICalling {
    // create a method for calling api which is return a Observable
    func send<T: Codable>(apiRequest: APIRequest) -> Observable<T> {
        return Observable<T>.create { observer in
            let request = apiRequest.request(with: apiRequest.baseURL)
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                do {
                    let model: countryModel = try JSONDecoder().decode(countryModel.self, from: data ?? Data())
                    observer.onNext( model.result as! T)
                } catch let error {
                    observer.onError(error)
                }
                observer.onCompleted()
            }
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
}
