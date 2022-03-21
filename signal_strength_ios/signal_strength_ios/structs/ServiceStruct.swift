//
//  ServiceStruct.swift
//  signal_strength_ios
//
//  Created by Jessie Hon on 2022-03-21.
//

import Foundation

struct ServiceStruct: Codable {
    var serviceUUID : String
    var serviceDescription : String
    var serviceCharacteristics : [CharacteristicStruct]?
}

struct CharacteristicStruct: Codable {
    var charDescription: String
}
