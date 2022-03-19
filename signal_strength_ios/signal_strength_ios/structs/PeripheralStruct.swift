//
//  PeripheralStruct.swift
//  signal_strength_ios
//
//  Created by Jessie Hon on 2022-03-19.
//

import Foundation

struct PeripheralStruct: Codable {
    var name: String?
    let identifier: String
    var rssi: String
}
