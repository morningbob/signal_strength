//
//  ServiceStruct.swift
//  signal_strength_ios
//
//  Created by Jessie Hon on 2022-03-21.
//

import Foundation

struct ServiceStruct: Codable {
    let serviceUUID : String
    let serviceDescription : String
    var serviceCharacteristics : [CharacteristicStruct]?
}

struct CharacteristicStruct: Codable {
    let charDescription: String
}
