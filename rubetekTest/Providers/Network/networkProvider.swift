//
//  networkProvider.swift
//  rubetekTest
//
//  Created by Vlad on 02.08.2021.
//

import Foundation
import UIKit
import Alamofire

class networkProvider {
    
    static var shared: networkProvider = {
        let provider = networkProvider()
        return provider
    }()
    
    private init() {}
    
    
    
    public func getDoors (completion: @escaping (Result<doorListCodable, AFError>) -> Void) {
        let jsonDecoder = JSONDecoder()
        AF.request(APIRouter.getDoorsList).responseDecodable(decoder : jsonDecoder) { (response : DataResponse <doorListCodable, AFError>) in
            completion(response.result)
        }
    }
    
    public func getCameras (completion: @escaping (Result<camerasListCodable, AFError>) -> Void) {
        let jsonDecoder = JSONDecoder()
        AF.request(APIRouter.getCamerasList).responseDecodable(decoder : jsonDecoder) { (response : DataResponse <camerasListCodable, AFError>) in
            completion(response.result)
        }
    }
    
    public func getImage (imageURL: String, completion: @escaping (Result<Data, Error>) -> Void) {
        
        AF.request(imageURL, method: .get).response { response in
            switch response.result {
            case .success(let responseData):
                completion(.success(responseData!))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

extension networkProvider: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}
