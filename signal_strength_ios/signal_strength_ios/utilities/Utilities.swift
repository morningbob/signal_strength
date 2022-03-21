//
//  Utilities.swift
//  signal_strength_ios
//
//  Created by Jessie Hon on 2022-03-21.
//

import Foundation

class Utilities {
    static var app: Utilities = {
        return Utilities()
    }()
    
    func getRSSIStrength(rssi: String) -> String {
        let rssiNumber = Double(rssi)!
        var stars = ""
        if (rssiNumber <= 10 && rssiNumber >= -10) {
            // best strength
            stars = "*******************"
        } else if (rssiNumber <= 20 && rssiNumber > 10) || (rssiNumber < -10 && rssiNumber >= -20){
            stars = "***************"
        } else if (rssiNumber <= 30 && rssiNumber > 20) || (rssiNumber < -20 && rssiNumber >= -30) {
            stars = "*************"
        } else if (rssiNumber <= 40 && rssiNumber > 30) || (rssiNumber < -30 && rssiNumber >= -40) {
            stars = "**********"
        } else if (rssiNumber <= 50 && rssiNumber > 40) || (rssiNumber < -40 && rssiNumber > -50) {
            stars = "********"
        } else if (rssiNumber <= 60 && rssiNumber > 50) || (rssiNumber < -50 && rssiNumber > -60) {
            stars = "******"
        } else if (rssiNumber <= 70 && rssiNumber > 60) || (rssiNumber < -60 && rssiNumber > -70) {
            stars = "*****"
        } else if (rssiNumber <= 80 && rssiNumber > 70) || (rssiNumber < -70 && rssiNumber > -80) {
            stars = "****"
        } else if (rssiNumber <= 90 && rssiNumber > 80) || (rssiNumber < -80 && rssiNumber > -90) {
            stars = "***"
        } else if (rssiNumber <= 100 && rssiNumber > 90) || (rssiNumber < -90 && rssiNumber > -100) {
            stars = "**"
        } else {
            stars = "*"
        }
        return stars
    }
}
