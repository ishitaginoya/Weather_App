//
//  WebService.swift
//  Weather App
//
//  Created by Ishita Ginoya on 14/12/24.
//

import Foundation
import Alamofire

class WebService: NSObject {
    func request<T: Decodable>(url: String,
                               method: HTTPMethod,
                               parameter: Parameters,
                               headers: HTTPHeaders?,
                               responseType: T.Type,
                               success: @escaping (T, Int) -> Void,
                               failure: @escaping (Error) -> Void) {
        AF.request(url, method: method, parameters: parameter, encoding: URLEncoding.queryString, headers: headers)
            .validate()
            .responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let decodedData):
                    success(decodedData, response.response?.statusCode ?? 0)
                case .failure(let error):
                    failure(error)
                }
            }
    }
}

