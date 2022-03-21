//
//  PeripheralDetailsViewController.swift
//  signal_strength_ios
//
//  Created by Jessie Hon on 2022-03-20.
//

import UIKit
import CoreBluetooth

class PeripheralDetailsViewController: UIViewController, CBCentralManagerDelegate {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var rssiLabel: UILabel!
    
    var chosenPeripheral : PeripheralStruct!
    var chosenCBPeripheral : CBPeripheral! {
        didSet {
            print("got chosen CB P")
        }
    }
    private var centralManager: CBCentralManager!
    private var connectedPeripheral: CBPeripheral! {
        didSet {
            print("got connected CB P")
            // start to explore services
        }
    }
    var passedPeripheral : CBPeripheral!
    var passedRSSI: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        centralManager = CBCentralManager(delegate: self, queue: nil)

        nameLabel.text = passedPeripheral.name
        idLabel.text = passedPeripheral.identifier.uuidString
        rssiLabel.text = passedRSSI + "   " + showRSSI(rssi: passedRSSI)
    }
    
    @IBAction func detectAction(_ sender: Any) {
        //centralManager
    }
    
    @IBAction func connectAction(_ sender: Any) {
        centralManager.connect(passedPeripheral)
        // after connected, read rssi
    }
    
    @IBAction func disconnectAction(_ sender: Any) {
        centralManager.cancelPeripheralConnection(passedPeripheral)
    }
    
    private func startScan() {
        centralManager.scanForPeripherals(withServices: nil)
    }
    
    func exploreServices() {
        
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            //startScan()
            //print("start scanning")
            print("power on")
        case .poweredOff:
            //centralManager.stopScan()
            print("stopped scanning")
        case .resetting:
            print("bluetooth is resetting")
        case .unauthorized:
            print("don't have bluetooth permission")
        case .unsupported:
            print("device doesn't have bluetooth")
        case .unknown:
            print("unkown problem")
        default:
            print("unkown problem")
        }
    }
    
    func showRSSI(rssi: String) -> String {
        let rssiNumber = Double(rssi)!
        var stars = ""
        // if rssi is near 0, it is the best strength
        // usually from 0 - 100, and 0 - -100
        // if it is near 0, set 9*
        // if it is > -70, acceptable, set 6*
        // -100, not good, set 2*
        //switch rssiNumber {
        //case rssiNumber <= 10 && rssiNumber >= -10:
        //    stars = "*******************"
        //}
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
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        //if peripheral.identifier == UUID(uuidString: chosenPeripheral.identifier){
        //    print("got the chosen device")
        //    self.chosenCBPeripheral = peripheral
        //}
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("successfully connected")
        self.connectedPeripheral = peripheral
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("failed to connect \(error?.localizedDescription)")
        // display an alert to user
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("There is error disconnecting: \(error?.localizedDescription)")
    }

}
