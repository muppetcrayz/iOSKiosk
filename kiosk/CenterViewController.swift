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

class CenterViewController: UIViewController, WKNavigationDelegate {
    
    let webView = WKWebView()
    let uiview = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        with(webView) {
            view.addSubview($0)
            
            let request = URLRequest(url: URL(string: "https://www.w3schools.com/jsref/met_win_alert.asp")!)
            $0.load(request)
            $0.navigationDelegate = self
            $0.allowsBackForwardNavigationGestures = true
            
            $0.snp.makeConstraints {
                $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
                $0.bottom.equalTo(view)
            }
        }
        
        let swipeRight = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.edges = .left
        self.view.addGestureRecognizer(swipeRight)
        
    }
    
    @objc
    func respondToSwipeGesture(_ recognizer: UIScreenEdgePanGestureRecognizer) {
        if (recognizer.state == .ended) {
            with(uiview) {
                view.addSubview($0)
                
                $0.backgroundColor = .white
                $0.layer.shadowColor = UIColor.darkGray.cgColor
                $0.layer.shadowRadius = 10
                $0.layer.shadowOpacity = 1
                $0.layer.shadowOffset = CGSize.zero
                
                $0.snp.makeConstraints {
                    $0.top.leading.bottom.equalTo(view.safeAreaLayoutGuide)
                    $0.width.equalTo(300)
                }
                
                let changeButton = UIButton()
                let reloadButton = UIButton()
                
                with(changeButton) {
                    $0.setTitle("Change URL", for: .normal)
                    $0.setTitleColor(.black, for: .normal)
                    $0.setImage(UIImage(named: "change"), for: .normal)
                    
                    uiview.addSubview($0)
                    
                    $0.addAction(for: .touchUpInside) {
                        let alert = UIAlertController(title: "Change URL", message: "Enter new URL with https://", preferredStyle: .alert)
                        alert.addTextField { (textField) in
                            textField.text = "https://www.google.com"
                        }
                        
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                            let text = alert?.textFields![0].text!
                            let request = URLRequest(url: URL(string: text ?? "https://www.google.com")!)
                            self.webView.load(request)
                        }))
                        
                        
                        self.present(alert, animated: true, completion: nil)
                        
                    }
                    
                    $0.snp.makeConstraints {
                        $0.top.leading.equalTo(view.safeAreaLayoutGuide).offset(15)
                    }
                }
                
                with(reloadButton) {
                    $0.setTitle("Refresh Page", for: .normal)
                    $0.setTitleColor(.black, for: .normal)
                    $0.setImage(UIImage(named: "refresh"), for: .normal)
                    
                    uiview.addSubview($0)
                    
                    $0.addAction(for: .touchUpInside) {
                        let request = URLRequest(url: URL(string: "https://www.tumblr.com")!)
                        self.webView.load(request)
                    }
                    
                    $0.snp.makeConstraints {
                        $0.top.equalTo(changeButton).offset(40)
                        $0.leading.equalTo(view.safeAreaLayoutGuide).offset(15)
                    }
                }
            }
        }
    }
}

