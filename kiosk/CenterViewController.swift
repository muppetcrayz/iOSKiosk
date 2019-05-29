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
import iOSDropDown

class CenterViewController: UIViewController, WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler, UIGestureRecognizerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var webView: WKWebView!
    let uiview = UIView()
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true
        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences
        configuration.userContentController.add(self, name: "test")
        configuration.userContentController.addUserScript(WKUserScript(source: "iframe.print = function() {window.webkit.messageHandlers.test.postMessage('print')}", injectionTime: .atDocumentEnd, forMainFrameOnly: false))
        
        webView = WKWebView(frame: .zero, configuration: configuration)
        
        with(webView) {
            view.addSubview($0!)
            
            let url = defaults.string(forKey: "url") ?? "https://ecommerce.dubtel.com"
            let request = URLRequest(url: URL(string: url)!)
            
            $0!.load(request)
            $0!.navigationDelegate = self
            $0!.uiDelegate = self
            
            $0!.snp.makeConstraints {
                $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
                $0.bottom.equalTo(view)
            }
        }
        
        with(uiview) {
            $0.isHidden = true
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
            let barButton = UIButton()
            let cafeButton = UIButton()
            let restaurantButton = UIButton()
            let retailButton = UIButton()
            
            with(changeButton) {
                $0.setTitle("Change Base URL", for: .normal)
                $0.setTitleColor(.black, for: .normal)
                $0.setImage(UIImage(named: "change"), for: .normal)
                
                uiview.addSubview($0)
                
                $0.addAction(for: .touchUpInside) {
                    let alert = UIAlertController(title: "Change Base URL", message: "Enter POS ID, terminal ID, and POS type", preferredStyle: .alert)
                    
                    alert.addTextField { (textField) in
                        textField.text = self.defaults.string(forKey: "id") ?? "ecommerce"
                    }
                    alert.addTextField { (textField) in
                        textField.text = self.defaults.string(forKey: "terminal") ?? "1"
                    }
                
                    alert.view.snp.makeConstraints {
                        $0.height.equalTo(250)
                    }
                    
                    let dropdown = DropDown(frame: CGRect(x: 25, y: 155, width: 240, height: 40))
                    dropdown.selectedIndex = 3
                    dropdown.optionArray = ["Bar", "Cafe", "Restaurant", "Retail"]
                    dropdown.optionIds = [0,1,2,3]
                    dropdown.text = "Select your POS type"
                    
                    dropdown.didSelect { (selectedText, index, id) in
                        switch selectedText {
                            case "Bar":
                                self.defaults.set("bar", forKey: "type")
                            case "Cafe":
                                self.defaults.set("cafe", forKey: "type")
                            case "Restaurant":
                                self.defaults.set("restaurant", forKey: "type")
                            case "Retail":
                                self.defaults.set("retail", forKey: "type")
                            default:
                                self.defaults.set("retail", forKey: "type")
                        }
                    }
                    
                    alert.view.addSubview(dropdown)

                    alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak alert] (_) in
                        let text1 = alert?.textFields![0].text!
                        self.defaults.set(text1, forKey: "id")
                        let text2 = alert?.textFields![1].text!
                        self.defaults.set(text2, forKey: "terminal")
                        var url = ""
                        if (text1! != "ecommerce") {
                            url = "https://pos" + text1! + ".dubtel.com"
                        }
                        else {
                            url = "https://ecommerce.dubtel.com"
                        }
                        var text = url + "/wp-terminal-session.php?id=" + text2! + "&pos_type="
                        text += self.defaults.string(forKey: "type") ?? "retail"
                        self.defaults.set(text, forKey: "url")
                        let request = URLRequest(url: URL(string: text)!)
                        self.webView.load(request)
                        self.uiview.isHidden = true
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
                    var url = ""
                    let id = self.defaults.string(forKey: "id") ?? "ecommerce"
                    if (id != "ecommerce") {
                        url = "https://pos" + id + ".dubtel.com"
                    }
                    else {
                        url = "https://ecommerce.dubtel.com"
                    }
                    url += "/wp-terminal-session.php?id="
                    url += self.defaults.string(forKey: "terminal") ?? "0" + "&pos_type="
                    url += self.defaults.string(forKey: "type") ?? "retail"
                    let request = URLRequest(url: URL(string: url)!)
                    self.webView.load(request)
                    self.uiview.isHidden = true
                }

                $0.snp.makeConstraints {
                    $0.top.equalTo(changeButton).offset(40)
                    $0.leading.equalTo(view.safeAreaLayoutGuide).offset(15)
                }
            }
            
            with(barButton) {
                $0.setTitle("Bar POS", for: .normal)
                $0.setTitleColor(.black, for: .normal)
                $0.setImage(UIImage(named: "bar"), for: .normal)
                
                uiview.addSubview($0)
                
                $0.addAction(for: .touchUpInside) {
                    var url = ""
                    let id = self.defaults.string(forKey: "id") ?? "ecommerce"
                    if (id != "ecommerce") {
                        url = "https://pos" + id + ".dubtel.com"
                    }
                    else {
                        url = "https://ecommerce.dubtel.com"
                    }
                    url += "/wp-terminal-session.php?id="
                    url += self.defaults.string(forKey: "id") ?? "0" + "&pos_type="
                    url += "bar"
                    self.defaults.set(url, forKey: "url")
                    let request = URLRequest(url: URL(string: url)!)
                    self.webView.load(request)
                    self.uiview.isHidden = true
                }
                
                $0.snp.makeConstraints {
                    $0.top.equalTo(reloadButton).offset(40)
                    $0.leading.equalTo(view.safeAreaLayoutGuide).offset(15)
                }
            }
            
            with(cafeButton) {
                $0.setTitle("Cafe POS", for: .normal)
                $0.setTitleColor(.black, for: .normal)
                $0.setImage(UIImage(named: "cafe"), for: .normal)
                
                uiview.addSubview($0)
                
                $0.addAction(for: .touchUpInside) {
                    var url = ""
                    let id = self.defaults.string(forKey: "id") ?? "ecommerce"
                    if (id != "ecommerce") {
                        url = "https://pos" + id + ".dubtel.com"
                    }
                    else {
                        url = "https://ecommerce.dubtel.com"
                    }
                    url += "/wp-terminal-session.php?id="
                    url += self.defaults.string(forKey: "terminal") ?? "0" + "&pos_type="
                    url += "cafe"
                    self.defaults.set(url, forKey: "url")
                    let request = URLRequest(url: URL(string: url)!)
                    self.webView.load(request)
                    self.uiview.isHidden = true
                }
                
                $0.snp.makeConstraints {
                    $0.top.equalTo(barButton).offset(40)
                    $0.leading.equalTo(view.safeAreaLayoutGuide).offset(15)
                }
            }
            
            with (restaurantButton) {
                $0.setTitle("Restaurant POS", for: .normal)
                $0.setTitleColor(.black, for: .normal)
                $0.setImage(UIImage(named: "restaurant"), for: .normal)
                
                uiview.addSubview($0)
                
                $0.addAction(for: .touchUpInside) {
                    var url = ""
                    let id = self.defaults.string(forKey: "id") ?? "ecommerce"
                    if (id != "ecommerce") {
                        url = "https://pos" + id + ".dubtel.com"
                    }
                    else {
                        url = "https://ecommerce.dubtel.com"
                    }
                    url += "/wp-terminal-session.php?id="
                    url += self.defaults.string(forKey: "terminal") ?? "0" + "&pos_type="
                    url += "restaurant"
                    self.defaults.set(url, forKey: "url")
                    let request = URLRequest(url: URL(string: url)!)
                    self.webView.load(request)
                    self.uiview.isHidden = true
                }
                
                $0.snp.makeConstraints {
                    $0.top.equalTo(cafeButton).offset(40)
                    $0.leading.equalTo(view.safeAreaLayoutGuide).offset(15)
                }
            }
            
            with (retailButton) {
                $0.setTitle("Retail POS", for: .normal)
                $0.setTitleColor(.black, for: .normal)
                $0.setImage(UIImage(named: "retail"), for: .normal)
                
                uiview.addSubview($0)
                
                $0.addAction(for: .touchUpInside) {
                    var url = ""
                    let id = self.defaults.string(forKey: "id") ?? "ecommerce"
                    if (id != "ecommerce") {
                        url = "https://pos" + id + ".dubtel.com"
                    }
                    else {
                        url = "https://ecommerce.dubtel.com"
                    }
                    url += "/wp-terminal-session.php?id="
                    url += self.defaults.string(forKey: "terminal") ?? "0" + "&pos_type="
                    url += "retail"
                    self.defaults.set(url, forKey: "url")
                    let request = URLRequest(url: URL(string: url)!)
                    self.webView.load(request)
                    self.uiview.isHidden = true
                }
                
                $0.snp.makeConstraints {
                    $0.top.equalTo(restaurantButton).offset(40)
                    $0.leading.equalTo(view.safeAreaLayoutGuide).offset(15)
                }
            }
        }
        
        let swipeRight = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.edges = .left
        swipeRight.delegate = self
        self.view.addGestureRecognizer(swipeRight)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.respondToTapGesture))
        tapGesture.delegate = self
        self.webView.addGestureRecognizer(tapGesture)
        
    }
    
    @objc
    func respondToTapGesture(_ gestureRecognizer : UITapGestureRecognizer) {
        if gestureRecognizer.state == .ended {
            if uiview.isHidden == false {
                uiview.isHidden = true
            }
        }
    }
    
    @objc
    func respondToSwipeGesture(_ recognizer: UIScreenEdgePanGestureRecognizer) {
        if (recognizer.state == .ended) {
            uiview.isHidden = false
        }
    }
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame == nil {
            webView.load(navigationAction.request)
        }
        return nil
    }
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo,
                 completionHandler: @escaping () -> Void) {
        
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            completionHandler()
        }))
        
        present(alertController, animated: true, completion: nil)
    }
    
    
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo,
                 completionHandler: @escaping (Bool) -> Void) {
        
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            completionHandler(true)
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
            completionHandler(false)
        }))
        
        present(alertController, animated: true, completion: nil)
    }
    
    
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo,
                 completionHandler: @escaping (String?) -> Void) {
        
        let alertController = UIAlertController(title: nil, message: prompt, preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.text = defaultText
        }
        
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            if let text = alertController.textFields?.first?.text {
                completionHandler(text)
            } else {
                completionHandler(defaultText)
            }
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
            completionHandler(nil)
        }))
        
        present(alertController, animated: true, completion: nil)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        webView.evaluateJavaScript("document.getElementById('iframe').contentWindow.document.body.outerHTML + document.getElementById('iframe').contentWindow.document.body.innerHTML") { result, error in
         
            let controller = UIPrintInteractionController.shared
            controller.printingItem = URL(string: result as! String)
            let printFormatter = self.webView.viewPrintFormatter()
            controller.printFormatter = printFormatter
            
            let completionHandler: UIPrintInteractionController.CompletionHandler = { (printController, completed, error) in
                if !completed {
                    if (error) != nil {
                        print("Wrong")
                    } else {
                        print("Cancelled")
                    }
                }
            }

            if UIDevice.current.userInterfaceIdiom == .pad {
                controller.present(from: CGRect.init(x: 0, y: 0, width: 30, height: 30), in: self.view, animated: true, completionHandler: completionHandler)
            } else {
                controller.present(animated: true, completionHandler: completionHandler)
            }
        }
        
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 4
    }
    
}

