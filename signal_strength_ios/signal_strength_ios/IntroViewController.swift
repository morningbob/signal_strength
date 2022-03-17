//
//  ViewController.swift
//  signal_strength_ios
//
//  Created by Jessie Hon on 2022-03-16.
//

import UIKit


class IntroViewController: UIViewController {
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    @IBAction func startDetectButton(_ sender: UIButton) {
        performSegue(withIdentifier: "detectDevicesSegue", sender: nil)
    }
    
    
}
    /*
extension IntroViewController: CBCentralManagerDelegate {
    
    fun cen
}
*/

