//
//  RequestProvider.swift
//  EuroTorgTestTask
//
//  Created by Ivan Apet on 7/29/20.
//  Copyright © 2020 Ivan Apet. All rights reserved.
//

import Moya

enum RequestsProvider {
    case getAllCountries
    case getRegions(countryId: Int)
    case getDistricts(regionId: Int)
    case getCities(districtId: Int)
    case getStreets(cityId: Int)
    
    func makePath() -> String {
        switch self {
        case .getAllCountries: return "/api/1.0/addresses/countries/"
        case .getRegions: return "/api/1.0/addresses/regions/"
        case .getDistricts: return "/api/1.0/addresses/districts/"
        case .getCities: return "/api/1.0/addresses/cities/"
        case .getStreets: return "/api/1.0/addresses/streets/"
        }
    }
    
     func makeTask() -> Task {
        switch self {
        case .getAllCountries:
            return .requestPlain
        case .getRegions(let id):
            let params: [String : Any] = ["country_id": id]
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        case .getDistricts(let id):
            let params: [String : Any] = ["region_id": id]
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        case .getCities(let id):
            let params: [String : Any] = ["district_id": id]
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        case .getStreets(let id):
            let params: [String : Any] = ["city_id": id]
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        }
    }
}

extension RequestsProvider: TargetType {
    var baseURL: URL {
        return URL(string: API_URL)!
    }
    
    var path: String {
        return makePath()
    }
    
    var method: Method {
        return .get
    }
    
    var sampleData: Data {
        return "{}".data(using: String.Encoding.utf8)!
    }
    
    var task: Task {
        return makeTask()
    }
    
    var headers: [String : String]? {
        var params = [String : String]()
        params["Content-Type"] = "application/json"
        params["Accept"] = "application/json"
        return params
    }
}
