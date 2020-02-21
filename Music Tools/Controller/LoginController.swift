//
//  LoginController.swift
//  Music Tools
//
//  Created by Ellie McCarthy on 19/02/2020.
//  Copyright © 2020 Sarsoo. All rights reserved.
//

import UIKit
import SwiftUI
import KeychainAccess

class LoginController: UIViewController, UITextFieldDelegate {
    
    // MARK: Properties
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var goButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: Actions
    @IBSegueAction func returnUIView(_ coder: NSCoder) -> UIViewController? {
        let liveUser = LiveUser(playlists: [], tags: [])
        return UIHostingController(coder: coder, rootView: RootView().environmentObject(liveUser))
    }
    
    var isLoggedIn: Bool? = nil {
        didSet {
            if self.isLoggedIn == true {
                self.performSegue(withIdentifier: "loginToMain", sender: self)
            } else if self.isLoggedIn == false {
                debugPrint("false logged in")
                self.isLoggedIn = nil
            } else {
                debugPrint("nil state")
            }
        }
    }
    
    @IBAction func doLogin(_ sender: Any) {
        
        let keychain = Keychain(service: "xyz.sarsoo.music.login")
        keychain["username"] = usernameField.text
        keychain["password"] = passwordField.text

        let api = UserApi.getUser
        RequestBuilder.buildRequest(apiRequest: api).responseJSON{ response in

            switch response.result {
            case .success:
                self.isLoggedIn = true
                break
            case .failure(let error):
                debugPrint("error: \(error)")
                self.isLoggedIn = false
                do {
                    try keychain.remove("username")
                    try keychain.remove("password")
                } catch let error {
                    debugPrint("Could not clear keychain, \(error)")
                }
                break
            }
        }
    }
    
    // block initial segue from button presson
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool { return false }
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
