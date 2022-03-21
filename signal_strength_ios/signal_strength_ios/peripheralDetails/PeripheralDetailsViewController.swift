//
//  PeripheralDetailsViewController.swift
//  signal_strength_ios
//
//  Created by Jessie Hon on 2022-03-20.
//

import UIKit
import CoreBluetooth

class PeripheralDetailsViewController: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate, UITableViewDelegate, UITableViewDataSource {
    
    
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var rssiLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
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
            self.exploreServices()
        }
    }
    var passedPeripheral : CBPeripheral!
    var passedRSSI: String!
    private var peripheralServices = [ServiceStruct]()
    //private var peripheralCharacteristics = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        centralManager = CBCentralManager(delegate: self, queue: nil)
        
        nameLabel.text = passedPeripheral.name
        idLabel.text = passedPeripheral.identifier.uuidString
        rssiLabel.text = passedRSSI + "   " + Utilities.app.getRSSIStrength(rssi: passedRSSI)
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
        connectedPeripheral.discoverServices(nil)
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
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
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("successfully connected")
        self.connectedPeripheral = peripheral
        peripheral.delegate = self
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("failed to connect \(error?.localizedDescription)")
        // display an alert to user
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("There is error disconnecting: \(error?.localizedDescription)")
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else {
            print("error: \(error?.localizedDescription)")
            return
        }
        print("discovered services")
        services.map { service in
            let newService = ServiceStruct(serviceUUID: service.uuid.uuidString, serviceDescription: service.description, serviceCharacteristics: nil)
            self.peripheralServices.append(newService)
        }
        self.discoverCharacteristics(peripheral: peripheral)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        
        guard let characteristics = service.characteristics else {
            print("Service \(service.description) has no characteristics")
            return
        }
        // here we get the particular service from our list using description
        for serviceStruct in self.peripheralServices {
            if (service.uuid.uuidString == serviceStruct.serviceUUID) {
                for characteristic in characteristics {
                    print("characteristic: \(characteristic.description)")
                    //self.peripheralCharacteristics.append(characteristic.description)
                    let charStruct = CharacteristicStruct(charDescription: characteristic.description)
                    serviceStruct.serviceCharacteristics?.append(charStruct)
                }
                break
            }
        }
        
    }

    func discoverCharacteristics(peripheral: CBPeripheral) {
        // we create service struct and charStruct here
        guard let services = peripheral.services else {
            return
        }
        for service in services {
            peripheral.discoverCharacteristics(nil, for: service)
            print("service: \(service.description)")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.peripheralServices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : ServiceCell! = tableView.dequeueReusableCell(withIdentifier: "ServiceCellUnit", for: indexPath) as! ServiceCell
        let service = self.peripheralServices[(indexPath as NSIndexPath).row]
        // configure service display here
        cell.serviceLabel.text = "Service: \(service.serviceDescription)\n Characteristics: \(service.serviceCharacteristics)"
        return cell
    }
}

class ServiceCell : UITableViewCell {
    
    @IBOutlet weak var serviceLabel: UILabel!
}
