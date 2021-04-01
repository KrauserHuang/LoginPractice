//
//  LoginViewController.swift
//  LoginPractice
//
//  Created by Tai Chin Huang on 2021/3/24.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    // Reference firestore object
    let db = Firestore.firestore()
//    let userData = db.collection(Constant.FireStore.users).document(uid)
    var uid = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func loginPressed(_ sender: UIButton) {
        let error = validateTextField()
        if error != nil {
            popAlert(title: "Error occured", message: error!, alertTitle: "OK") { (action) in
                self.emailTextField.text = ""
                self.passwordTextField.text = ""
            }
        } else {
            if let email = emailTextField.text,
               let password = passwordTextField.text {
                Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                    // remove [weak self] & guard let strongSelf = self else { return }
                    if let error = error {
                        self.popAlert(title: "Error occured", message: error.localizedDescription, alertTitle: "OK") { (action) in
                            self.emailTextField.text = ""
                            self.passwordTextField.text = ""
                        }
                        print(error.localizedDescription)
                    } else {
                        if let user = Auth.auth().currentUser {
                            self.uid = user.uid
                            self.performSegue(withIdentifier: Constant.Segue.loginSegue, sender: self)
                            print("login success!")
                            print(self.uid)
                        }
                    }
                }
            }
        }
    }
    /*
     Check all textFields and validate that the data is correct,
     if everything is correct, this method returns nil,
     otherwise, it will return error message
     1. 確保所有textField都有輸入值
     */
    func validateTextField() -> String? {
        // Check all textFields are filled in, 檢查所有的textField是否都有輸入
        if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill in all fields."
        }
        return nil
    }
    
    // Question: Why don't need @escaping on action
    func popAlert(title: String, message: String, alertTitle: String, action: ((UIAlertAction) -> Void)?) {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alert = UIAlertAction(title: alertTitle, style: .cancel, handler: action)
        controller.addAction(alert)
        present(controller, animated: true, completion: nil)
    }
    
    func getUserInfo(uid: String) {
        db.collection(Constant.FireStore.users).document(uid).addSnapshotListener { (documentSnapshot, error) in
            guard let document = documentSnapshot else {
                print("Error fetching document, \(error!)")
                return
            }
            guard let data = document.data() else {
                print("Document data was empty")
                return
            }
            print("Current data: \(data)")
        }
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
