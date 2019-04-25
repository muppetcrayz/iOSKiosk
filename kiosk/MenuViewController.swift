//
//  MenuViewController.swift
//  kiosk
//
//  Created by Sage Conger on 4/25/19.
//  Copyright © 2019 dubtel. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    let changeButton = UIButton()
    let reloadButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        with(changeButton) {
            $0.setTitle("Change Page", for: .normal)
            
            view.addSubview($0)
            
            $0.addAction(for: .touchUpInside) {
                
            }
            
            $0.snp.makeConstraints {
                $0.top.leading.equalTo(view.safeAreaLayoutGuide)
            }
        }
        
        with(reloadButton) {
            $0.setTitle("Reload Page", for: .normal)
            
            view.addSubview($0)
            
            $0.addAction(for: .touchUpInside) {
                
            }
            
            $0.snp.makeConstraints {
                $0.top.equalTo(changeButton).offset(50)
                $0.leading.equalTo(view.safeAreaLayoutGuide)
            }
        }
    }

}
