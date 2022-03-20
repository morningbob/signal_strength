//
//  ViewController.swift
//  signal_strength_ios
//
//  Created by Jessie Hon on 2022-03-16.
//

import UIKit


class IntroViewController: UIViewController {
    
    var dataController: DataController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    @IBAction func startDetectButton(_ sender: UIButton) {
        performSegue(withIdentifier: "toResultVC", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toResultVC" {
            let resultVC = segue.destination as! ResultViewController
            resultVC.dataController = dataController
        }
    }
}
    /*
extension IntroViewController: CBCentralManagerDelegate {
    
    fun cen
}
*/

