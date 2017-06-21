//
//  WebReqViewController.swift
//  CircularDesigns
//
//  Created by Kiranbabu Rajanala on 10/28/16.
//  Copyright © 2016 Kiranbabu Rajanala. All rights reserved.
//

import UIKit

class WebReqViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var UrlTextfield: UITextField!
    @IBOutlet weak var GoButton: UIButton!
    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        GoButton.layer.cornerRadius = 5
        hideKeyboardWhenTappedAround()
         self.UrlTextfield.delegate = self
        
       

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func GoTapped(_ sender: AnyObject) {
       dismissKeyboard()
        self.webView.loadRequest(URLRequest(url: NSURL(string: "about:blank") as! URL))
      Validate()
    }
    
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        self.webView.loadRequest(URLRequest(url: NSURL(string: "about:blank") as! URL))
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dismissKeyboard()
        Validate()
        return true
    }
    
    func Validate() {
    
        let selectedUrl = UrlTextfield.text
        
        
        NSURL.validateUrl(urlString: selectedUrl) { (success, OutputString, error) in
            
            print(success, OutputString as Any, error)
            
            if success {
                
                self.webView.loadRequest(URLRequest(url: NSURL(string: OutputString!) as! URL))
                
            } else {
                
                self.AlertView(message: error as String)
            }
        }
    
    }

    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    func AlertView(message:String) {
        let alert = UIAlertController(title: "Error!", message:message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
