//
//  ViewController.swift
//  SoudtouchPresets
//
//  Created by Bastian Bukatz on 12.07.17.
//  Copyright © 2017 Bastian Bukatz. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!
    
    var soundtouch:HTTPCommunication = HTTPCommunication()
   
    @IBAction func didPressGetPresets(_ sender: Any) {
        
        textView.text = soundtouch.getPreset()
        
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

