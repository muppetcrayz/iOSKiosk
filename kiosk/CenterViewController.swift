//
//  ViewController.swift
//  kiosk
//
//  Created by Sage Conger on 4/24/19.
//  Copyright © 2019 dubtel. All rights reserved.
//

import UIKit
import SnapKit
import WebKit

class CenterViewController: UIViewController {
    
    let webView = WKWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        with(webView) {
            view.addSubview($0)
            
            let request = URLRequest(url: URL(string: "https://www.google.com")!)
            $0.load(request)
            
            $0.snp.makeConstraints {
                $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
                $0.bottom.equalTo(view)
            }
        }
    }

}

