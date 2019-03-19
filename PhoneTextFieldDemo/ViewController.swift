//
//  ViewController.swift
//  PhoneTextFieldDemo
//
//  Created by allen_zhang on 2019/3/13.
//  Copyright © 2019 com.mljr. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var text: PhoneField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        text = PhoneField(frame: CGRect(x: 40, y: 70, width: UIScreen.main.bounds.size.width-70, height: 50))
        self.view.addSubview(text)
    }


}

