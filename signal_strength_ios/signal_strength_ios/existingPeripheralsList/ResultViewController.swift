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
    private var currentCBPeripherals = [CBPeripheral]()
    var dataController: DataController!
    private var rssiList = [String]()
    
    
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
        let incomingRSSI = Double(truncating: RSSI)
        print("incoming rssi: \(incomingRSSI)")
        insertNewDeviceOrUpdateOldDevice(newDevice: peripheral, rssi: String(incomingRSSI))
        
    }
    
    func insertNewDeviceOrUpdateOldDevice(newDevice: CBPeripheral, rssi: String) {
        var found = false
        var existingDeviceIndex = 0
        var existingDevices = self.currentCBPeripherals.enumerated().map { index, device -> CBPeripheral in
            if device.identifier == newDevice.identifier {
                // tableview row should be updated here
                existingDeviceIndex = index
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
            self.currentCBPeripherals.append(newDevice)
            self.rssiList.append(rssi)
            tableView.insertRows(at: [IndexPath(row: self.currentCBPeripherals.count - 1, section: 0)], with: .fade)
        } else {
            // instead of updating CB P's value, we can replace the P variable
            self.currentCBPeripherals[existingDeviceIndex] = newDevice
            self.rssiList[existingDeviceIndex] = rssi
            //self.currentCBPeripherals[existingDeviceIndex].name = newDevice.name
            //self.currentCBPeripherals[existingDeviceIndex].rssi = rssi
            tableView.reloadRows(at: [IndexPath(row: existingDeviceIndex, section: 0)], with: .fade)
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentCBPeripherals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : PeripheralCell! = tableView .dequeueReusableCell(withIdentifier: "PeripheralCellUnit", for: indexPath) as? PeripheralCell
        let peripheral = self.currentCBPeripherals[(indexPath as NSIndexPath).row]
        
        cell.nameLabel?.text = (peripheral.name != nil) ? peripheral.name : "unkown"
        cell.rssiLabel?.text = rssiList[indexPath.row]
        //var numStars = showRSSI(rssi: rssiList[indexPath.row])
        var numStars = Utilities.app.getRSSIStrength(rssi: rssiList[indexPath.row])
        cell.starsLabel?.text = numStars
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // we stop the scanning before navigating away
        centralManager.stopScan()
        // navigate to the particular peripheral, and show it's details
        let detailsVC = self.storyboard!.instantiateViewController(withIdentifier: "PeripheralDetailsViewController") as! PeripheralDetailsViewController
        detailsVC.passedPeripheral = self.currentCBPeripherals[indexPath.row]
        detailsVC.passedRSSI = self.rssiList[indexPath.row]
        self.navigationController!.pushViewController(detailsVC, animated: true)
    }
    
}

class PeripheralCell : UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var rssiLabel: UILabel!
    @IBOutlet weak var starsLabel: UILabel!
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

