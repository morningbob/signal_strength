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
    private var discoveredPeripherals = [Peripheral]()
    private var discovered = Set<CBPeripheral>()
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
        //let newDevice = Peripheral(name: peripheral.name, identifier: peripheral.identifier.uuidString, rssi: String(incomingRSSI))
        
        // before creating a new device, can check if the device with
        // the identifier exist
        let fetchRequest : NSFetchRequest<Peripheral> = Peripheral.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "identifier", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        if let result = try? dataController.viewContext.fetch(fetchRequest) {
            existingPeripheralResult = result
        }
        if !existingPeripheralResult.isEmpty {
            print("peripheral already exists")
        } else {
        
            let newDevice = Peripheral(context: dataController.viewContext)
            newDevice.name = peripheral.name
            newDevice.identifier = peripheral.identifier.uuidString
            newDevice.rssi = String(incomingRSSI)
            
            try? dataController.viewContext.save()
            //self.discoveredPeripherals.append(newDevice)
            //tableView.insertRows(at: [indexPath], with: .fade)
            
            tableView.reloadData()
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return discovered.count//discoveredPeripherals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : PeripheralCell! = tableView.dequeueReusableCell(withIdentifier: "PeripheralCellUnit")! as? PeripheralCell
        let peripheral = self.discoveredPeripherals[(indexPath as NSIndexPath).row]
        
        cell.peripheralNameLabel?.text = peripheral.name

        cell.rssiLabel?.text = peripheral.rssi
        
        
        return cell
    }
    
}

class PeripheralCell : UITableViewCell {
    
    
    @IBOutlet weak var peripheralNameLabel: UILabel!
    @IBOutlet weak var rssiLabel: UILabel!
    
}




