//
//  ViewController.swift
//  mach_portal
//
//  Created by Ian Beer on 11/27/16.
//  Copyright © 2016 Ian Beer. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var statusLabel: UILabel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        statusLabel.text = "Working"
        activityIndicator.startAnimating()
        
        DispatchQueue.main.async(execute: { () -> Void in
            jb_go();
        })
        
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()

    }

}

