//
//  loginpagecontroller.swift
//  idashboard
//
//  Created by Hasanul Isyraf on 24/04/2018.
//  Copyright © 2018 Hasanul Isyraf. All rights reserved.
//

import UIKit
import FirebaseAuth

class loginpagecontroller: UIViewController {

    @IBOutlet weak var loginbutton: UIButton!
    
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var email: UITextField!
    
   
    
    override func viewDidAppear(_ animated: Bool) {
        
       FIRAuth.auth()?.addStateDidChangeListener { (auth, user) in
        
        let emailstr : String = self.email.text!
        if(user != nil){
            if !(user?.isEmailVerified)!{
                let alertVC = UIAlertController(title: "Error", message: "Sorry. Your email address has not yet been verified. Do you want us to send another verification email to \(emailstr).", preferredStyle: .alert)
                let alertActionOkay = UIAlertAction(title: "Okay", style: .default) {
                    (_) in
                    user?.sendEmailVerification(completion: nil)
                }
                let alertActionCancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
                
                alertVC.addAction(alertActionOkay)
                alertVC.addAction(alertActionCancel)
                self.present(alertVC, animated: true, completion: nil)
            }else{
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            let initialViewController2 = storyboard.instantiateViewController(withIdentifier: "dashboard") as! dashboardpage
            
            self.navigationController?.pushViewController(initialViewController2, animated: true)
            }
            
        }
        }
      
      
    }
   
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
      loginbutton.layer.cornerRadius = 10
        
    
       
    }

   
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
  

    @IBAction func loginaction(_ sender: Any) {
        let email : String = self.email.text!
        let password: String = self.password.text!
        
//        FIRAuth.auth()?.signIn(withEmail: email, password: password) { (user, error) in
//
//        if(error == nil){
//
//            if(user != nil){
//                if(user?.isEmailVerified == true){
//
//                self.showToast(message: (user?.email!)!)
//
//                FIRAuth.auth()?.addStateDidChangeListener { (auth, user) in
//
//
//
//
//
//                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//
//                        let initialViewController2 = storyboard.instantiateViewController(withIdentifier: "dashboard") as! dashboardpage
//
//                        self.navigationController?.pushViewController(initialViewController2, animated: true)
//
//
//
//                }
//
//                    }
//
//                    else{
//
//                        self.showToast(message: "Please verify your email")
//
//                    }
//                }
//            }else{
//
//                self.showToast(message: error.debugDescription)
//            }
//
//        }

        
        FIRAuth.auth()?.signIn(withEmail: email, password: password) {
            (user, error) in
            if let user = FIRAuth.auth()?.currentUser {
                if !user.isEmailVerified{
                    let alertVC = UIAlertController(title: "Error", message: "Sorry. Your email address has not yet been verified. Do you want us to send another verification email to \(email).", preferredStyle: .alert)
                    let alertActionOkay = UIAlertAction(title: "Okay", style: .default) {
                        (_) in
                        user.sendEmailVerification(completion: nil)
                    }
                    let alertActionCancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
                    
                    alertVC.addAction(alertActionOkay)
                    alertVC.addAction(alertActionCancel)
                    self.present(alertVC, animated: true, completion: nil)
                } else {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    
                                            let initialViewController2 = storyboard.instantiateViewController(withIdentifier: "dashboard") as! dashboardpage
                    
                                            self.navigationController?.pushViewController(initialViewController2, animated: true)
                }
            }
            
            if(error != nil){
                
               
                    
                    let alertVC = UIAlertController(title: "Error", message: error.debugDescription, preferredStyle: .alert)
                    let alertActionOkay = UIAlertAction(title: "Okay", style: .default) {
                        (_) in
                        
                    }
                    
                    
                    alertVC.addAction(alertActionOkay)
                    
                    self.present(alertVC, animated: true, completion: nil)
                    
                
            }
        }
        
        
    }
    
    
    @IBAction func resetpasswordaction(_ sender: Any) {
        
        let emailtoreset = email.text
        
        if(emailtoreset?.isEmpty)!{
            
            showToast(message: "Pls key in your valid email account")
            
        }else{
            FIRAuth.auth()?.sendPasswordReset(withEmail: emailtoreset!) { error in
                
                if(error == nil){
                    self.showToast(message: "An email to reset your password has been sent")}else{
                    self.showToast(message: error.debugDescription)
                }
        }
        }
    }
    
    
}
