//
//  APIRouter.swift
//  rubetekTest
//
//  Created by Vlad on 03.08.2021.
//

import Foundation
import Alamofire

enum APIRouter: URLRequestConvertible {
    
    case getCamerasList
    case getDoorsList
    
    private var path : String {
        switch self {
        case .getCamerasList:
            return "/cameras"
        case .getDoorsList:
            return "/doors"
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        
        let url = try configs.shared.baseURL.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = HTTPMethod.get.rawValue
        
        do {
            urlRequest = try URLEncoding.default.encode(urlRequest, with: nil)
        } catch {
            throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
        }
        return urlRequest
    }
}
