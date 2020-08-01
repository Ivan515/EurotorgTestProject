//
//  BaseModel.swift
//  EuroTorgTestTask
//
//  Created by Ivan Apet on 7/29/20.
//  Copyright © 2020 Ivan Apet. All rights reserved.
//

class BaseModel: Decodable {
    
    var id: Int?
    var name: String?
    var status: Int?
    var nameClean: String?
    var districtId: Int?
    var latitude: String?
    var longitude: String?
    
    enum MovieCodingKeys: String, CodingKey {
        case id
        case name
        case status
        case name_clean
        case district_id
        case latitude
        case longitude
    }
    
    required convenience init(from decoder: Decoder) throws {
        self.init()
        let values = try decoder.container(keyedBy: MovieCodingKeys.self)
        
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        nameClean = try values.decodeIfPresent(String.self, forKey: .name_clean)
        districtId = try values.decodeIfPresent(Int.self, forKey: .district_id)
        latitude = try values.decodeIfPresent(String.self, forKey: .latitude)
        longitude = try values.decodeIfPresent(String.self, forKey: .longitude)
    }
}

