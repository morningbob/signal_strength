//
//  ResultViewController.swift
//  signal_strength_ios
//
//  Created by Jessie Hon on 2022-03-16.
//

import UIKit
import CoreBluetooth

class ResultViewController: UIViewController , CBCentralManagerDelegate,
    UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    private var centralManager: CBCentralManager!
    private var discoveredPeripherals = [Peripheral]()
    private var discovered = Set<CBPeripheral>()
    private var appDelegate: AppDelegate!
    private var dataController: DataController!
    //private var context : ViewContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        centralManager = CBCentralManager(delegate: self, queue: nil)
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate
        
    }
    
    private func startScan() {
        centralManager.scanForPeripherals(withServices: nil)
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        var sum: Int
        switch central.state {
        case .poweredOn:
            startScan()
            print("start scaning")
        case .poweredOff:
            sum = 2
        case .resetting:
            sum = 3
        case .unauthorized:
            sum = 4
        case .unsupported:
            sum = 5
        case .unknown:
            sum = 6
        default:
            sum = 7
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("did discovered")
        print("device: \(peripheral.identifier)")
        //print("rssi: \(peripheral.rssi)")
        //self.discoveredPeripherals.append(peripheral)
        let incomingRSSI = Double(truncating: RSSI)
        print("incoming rssi: \(incomingRSSI)")
        //self.discovered.insert(peripheral)
        //self.discoveredPeripherals = Array(self.discovered).sorted(by: //{$0.identifier.uuidString > $1.identifier.uuidString})
        // create a new peripheral
        //let newDevice = Peripheral(name: peripheral.name, identifier: peripheral.identifier.uuidString, rssi: String(incomingRSSI))
        let newDevice = Peripheral()
        newDevice.name = peripheral.name
        newDevice.identifier = peripheral.identifier.uuidString
        newDevice.rssi = String(incomingRSSI)
        self.discoveredPeripherals.append(newDevice)
        //print(peripheral.readRSSI())
        tableView.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return discovered.count//discoveredPeripherals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : PeripheralCell! = tableView.dequeueReusableCell(withIdentifier: "PeripheralCellUnit")! as? PeripheralCell
        let peripheral = self.discoveredPeripherals[(indexPath as NSIndexPath).row]
        
        cell.peripheralNameLabel?.text = peripheral.name

        cell.rssiLabel?.text = peripheral.rssi
        
        //tableView.insertRows(at: [indexPath], with: .fade)
        return cell
    }
    
}

class PeripheralCell : UITableViewCell {
    
    
    @IBOutlet weak var peripheralNameLabel: UILabel!
    @IBOutlet weak var rssiLabel: UILabel!
    
    //override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    //    super.init(style: style, reuseIdentifier: reuseIdentifier)
    //}
}


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


