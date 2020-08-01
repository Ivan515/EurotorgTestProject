//
//  NetworkManager.swift
//  EuroTorgTestTask
//
//  Created by Ivan Apet on 7/29/20.
//  Copyright © 2020 Ivan Apet. All rights reserved.
//

import Moya
import SwiftyJSON
import Result

class NetworkManager {
    private let provider = MoyaProvider<RequestsProvider>(plugins: [NetworkLoggerPlugin(verbose: true, requestDataFormatter: { (data) -> (String) in
        guard let object = try? JSONSerialization.jsonObject(with: data, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return "\n\nJSON ERROR ON MY SIDE\n\n" }

        return prettyPrintedString as String
    }, responseDataFormatter: { (data) -> (Data) in
        guard let object = try? JSONSerialization.jsonObject(with: data, options: []),
            let dataFormatted = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]) else {return data}
        
        return dataFormatted
    })])
}

// MARK: -
// MARK: - Public requests

extension NetworkManager {
    func getAllCountries(completion: @escaping(_ models: [BaseModel]?, _ error: NSError?) -> ()) {
        provider.request(.getAllCountries) { (result) in
            self.handleArrayOfModels(result, completion: completion)
        }
    }
    
    func getRegions(countryId: Int, completion: @escaping(_ models: [BaseModel]?, _ error: NSError?) -> ()) {
        provider.request(.getRegions(countryId: countryId)) { (result) in
            self.handleArrayOfModels(result, completion: completion)
        }
    }
    
    func getDistricts(regionId: Int, completion: @escaping(_ models: [BaseModel]?, _ error: NSError?) -> ()) {
        provider.request(.getDistricts(regionId: regionId)) { (result) in
            self.handleArrayOfModels(result, completion: completion)
        }
    }
    
    func getCities(districtId: Int, completion: @escaping(_ models: [BaseModel]?, _ error: NSError?) -> ()) {
        provider.request(.getCities(districtId: districtId)) { (result) in
            self.handleArrayOfModels(result, completion: completion)
        }
    }
    
    func getStreets(cityId: Int, completion: @escaping(_ models: [BaseModel]?, _ error: NSError?) -> ()) {
        provider.request(.getStreets(cityId: cityId)) { (result) in
            self.handleArrayOfModels(result, completion: completion)
        }
    }

}


private extension NetworkManager {
    func handleModelResponse<ModelType: Decodable>(_ result: Result<Response, MoyaError>, completion: @escaping(_ answer: ModelType?, _ error: NSError?) -> ()) {
        switch result {
        case let .success(moyaResponse):
            let statusCode = moyaResponse.statusCode
            switch statusCode {
            case 200...300:
                var model: ModelType? = nil
                do {
                    let json = try JSONDecoder().decode(JSON.self, from: moyaResponse.data)
                    model = try JSONDecoder().decode(ModelType.self, from: json["result"].rawData())
                } catch {
                    print("\n\n\nJSON decode error: \n\(error).\n\n\n")
                }
                completion(model, nil)
            case 401:
                print("Autorization Failed")
                completion(nil, nil)
            case 500:
                print("error 500")
                completion(nil, nil)
            default:
                print("some error")
                completion(nil, nil)
            }
        case let .failure(error):
            print(error)
            completion(nil, nil)
//            completion(nil, er)
        }
    }
    
    func handleArrayOfModels<ModelType: Decodable>(_ result: Result<Response, MoyaError>, completion: @escaping(_ answer: ModelType?, _ error: NSError?) ->()) {
        switch result {
        case let .success(moyaResponse):
            let statusCode = moyaResponse.statusCode
            switch statusCode {
            case 200...300:
                var model: ModelType? = nil
                do {
                    let json = try JSONDecoder().decode(JSON.self, from: moyaResponse.data)
                    model = try JSONDecoder().decode(ModelType.self, from: json["data"].rawData())
                } catch {
                    print("\n\n\nJSON decode error: \n\(error).\n\n\n")
                }
                completion(model, nil)
            case 401:
                print("Autorization Failed")
                completion(nil, nil)
            case 500:
                print("error 500")
                completion(nil, nil)
            default:
                print("some error")
                completion(nil, nil)
            }
        case let .failure(error):
            print("Request error", error)
            completion(nil, nil)
        }
    }
}
