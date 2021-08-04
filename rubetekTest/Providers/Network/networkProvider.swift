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
    
    public static func getDoors (completion: @escaping (Result<doorList, AFError>) -> Void) {
        let jsonDecoder = JSONDecoder()
        AF.request(APIRouter.getDoorsList).responseDecodable(decoder : jsonDecoder) { (response : DataResponse <doorList, AFError>) in
            completion(response.result)
        }
    }
    
    public static func getCameras (completion: @escaping (Result<camerasList, AFError>) -> Void) {
        let jsonDecoder = JSONDecoder()
        AF.request(APIRouter.getCamerasList).responseDecodable(decoder : jsonDecoder) { (response : DataResponse <camerasList, AFError>) in
            completion(response.result)
        }
    }
    
    public func getImage (imageURL: String, completion: @escaping (Result<Data?, Error>) -> Void) {
        
        AF.request(imageURL, method: HTTPMethod.get).response { response in
            switch response.result {
            case .success(let responseData):
                completion(.success(responseData!))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
