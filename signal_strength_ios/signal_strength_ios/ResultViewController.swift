//
//  ResultViewController.swift
//  signal_strength_ios
//
//  Created by Jessie Hon on 2022-03-16.
//

import UIKit
import CoreBluetooth
import CoreData

class ResultViewController: UIViewController , CBCentralManagerDelegate,
    UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    private var centralManager: CBCentralManager!
    private var discoveredPeripherals = [CBPeripheral]()
    private var discoveredSet = Set<CBPeripheral>()
    private var currentPeripherals = [PeripheralStruct]()
    var dataController: DataController!
    private var existingPeripheralResult = [Peripheral]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        centralManager = CBCentralManager(delegate: self, queue: nil)
        
    }
    
    private func startScan() {
        centralManager.scanForPeripherals(withServices: nil)
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            startScan()
            print("start scaning")
        case .poweredOff:
            centralManager.stopScan()
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
        print("did discovered")
        print("device: \(peripheral.identifier)")
        //self.discoveredPeripherals.append(peripheral)
        let incomingRSSI = Double(truncating: RSSI)
        print("incoming rssi: \(incomingRSSI)")
        //self.discovered.insert(peripheral)
        //self.discoveredPeripherals = Array(self.discovered).sorted(by: //{$0.identifier.uuidString > $1.identifier.uuidString})
        // create a new peripheral
        //let newDevice = Peripheral(name: peripheral.name, identifier: peripheral.identifce(: PeripheralStruct) {
        // check if the device is already exist:
        let newDevice = PeripheralStruct(name: peripheral.name, identifier: peripheral.identifier.uuidString, rssi: String(incomingRSSI))
        insertNewDeviceOrUpdateOldDevice(newDevice: newDevice)
        //self.currentPeripherals
    }
    
    func insertNewDeviceOrUpdateOldDevice(newDevice: PeripheralStruct) {
        var found = false
        var existingDevices = self.currentPeripherals.map { device -> PeripheralStruct in
            if device.identifier == newDevice.identifier {
                // tableview row should be updated here
                // how can we get the index
                found = true
                return newDevice
            } else {
                return device
            }
        }
         
        if found == false {
            // doesn't need to add, update name and rssi
            // append to currentPeripherals, update table
            // add the new device at the end of current list, since it is not
            // added earlier.
            existingDevices.append(newDevice)
            self.currentPeripherals = existingDevices
            tableView.insertRows(at: [IndexPath(row: self.currentPeripherals.count - 1, section: 0)], with: .fade)
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentPeripherals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : PeripheralCell! = tableView .dequeueReusableCell(withIdentifier: "PeripheralCellUnit", for: indexPath) as? PeripheralCell
        let peripheral = self.currentPeripherals[(indexPath as NSIndexPath).row]
        
        cell.nameLabel?.text = (peripheral.name != nil) ? peripheral.name : "unkown"

        cell.rssiLabel?.text = peripheral.rssi
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
}

class PeripheralCell : UITableViewCell {
    
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var rssiLabel: UILabel!
}


/*
let fetchRequest : NSFetchRequest<Peripheral> = Peripheral.fetchRequest()
let sortDescriptor = NSSortDescriptor(key: "identifier", ascending: false)
fetchRequest.sortDescriptors = [sortDescriptor]
if let result = try? dataController.viewContext.fetch(fetchRequest) {
    existingPeripheralResult = result
}
if !existingPeripheralResult.isEmpty {
    print("peripheral already exists")
} else {
    // device not exist
    let newDevice = Peripheral(context: dataController.viewContext)
    newDevice.name = peripheral.name
    newDevice.identifier = peripheral.identifier.uuidString
    newDevice.rssi = String(incomingRSSI)
    
    try? dataController.viewContext.save()
    self.discoveredPeripherals.append(newDevice)
    //tableView.insertRows(at: [indexPath], with: .fade)
    
    tableView.reloadData()
}
 */
/*
var newDeviceList = [PeripheralStruct]()
var found = false
for device in self.currentPeripherals {
   if device.identifier == newDevice.identifier {
       newDeviceList.append(newDevice)
       
       // table row has been updated
       found = true
       //break
   } else {
       newDeviceList.append(device)
   }
}
 */

