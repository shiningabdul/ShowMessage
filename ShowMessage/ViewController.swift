//
//  ViewController.swift
//  ShowMessage
//
//  Created by Abdul Aljebouri on 2018-10-07.
//  Copyright © 2018 shiningdevelopers. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var messageField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func showButtonTapped(_ sender: Any) {
        guard let newMessage = messageField.text else {
            return
        }
        
        messageLabel.text = newMessage
        
        let intent = IntentManager.shared.intent(withMessage: newMessage)
        IntentManager.shared.donateShortcuts(withIntent: intent)
    }
}

