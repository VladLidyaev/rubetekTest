//
//  networkProvider.swift
//  rubetekTest
//
//  Created by Vlad on 02.08.2021.
//

import Foundation
import Alamofire

class networkProvider {
    
    static func getDoors (completion: @escaping (Result<doorList, AFError>) -> Void) {
        let jsonDecoder = JSONDecoder()
        AF.request(APIRouter.getDoorsList).responseDecodable(decoder : jsonDecoder) { (response : DataResponse <doorList, AFError>) in
            completion(response.result)
        }
    }
}

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
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: [], options: [])
        } catch {
            throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
        }
        
        return urlRequest
    }
}
