//
//  ragistrationctrl.swift
//  idashboard
//
//  Created by Hasanul Isyraf on 25/04/2018.
//  Copyright © 2018 Hasanul Isyraf. All rights reserved.
//

import UIKit
import FirebaseAuth

class ragistrationctrl: UIViewController {
    
    
    @IBOutlet weak var emailinput: UITextField!
    
    @IBOutlet weak var passwordinput: UITextField!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    
    @IBAction func actionbutton(_ sender: Any) {
        
        let email : String = self.emailinput.text!
        let password: String = self.passwordinput.text!
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password) { (user, error) in
            
            if(error != nil){
            print(error.debugDescription)
            }
            else{
                let alertVC = UIAlertController(title: "Alert", message: "Press ok for verification email will be sent to \(email).", preferredStyle: .alert)
                let alertActionOkay = UIAlertAction(title: "Okay", style: .default) {
                    (_) in
                    user?.sendEmailVerification(completion: nil)
                }
                let alertActionCancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
                
                alertVC.addAction(alertActionOkay)
                alertVC.addAction(alertActionCancel)
                self.present(alertVC, animated: true, completion: nil)
                  user?.sendEmailVerification(completion: nil)
            }
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
 
    
    
    
}

extension UIViewController {
    
    func showToast(message : String) {
        
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 150, y: self.view.frame.size.height-100, width: 300, height: 100))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 8)
        toastLabel.numberOfLines = 0
        toastLabel.contentMode = .scaleToFill
     
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    
}
