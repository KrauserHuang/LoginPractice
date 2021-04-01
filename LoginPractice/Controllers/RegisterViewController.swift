//
//  RegisterViewController.swift
//  LoginPractice
//
//  Created by Tai Chin Huang on 2021/3/24.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repasswordTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    
    let db = Firestore.firestore()
    var uid = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func signUpPressed(_ sender: UIButton) {
        // Validate the field, 先對textField做判斷
        let error = validateTextField()
        if error != nil {
            popAlert(title: "Error occured", message: error!, alertTitle: "OK") { (action) in
                self.emailTextField.text = ""
                self.passwordTextField.text = ""
                self.repasswordTextField.text = ""
                self.userNameTextField.text = ""
            }
        } else {
            // 將textField輸入的文字存入常數中
            if let email = emailTextField.text,
               let password = passwordTextField.text,
               let userName = userNameTextField.text {
                // 建立user
                Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                    if let error = error {
                        self.popAlert(title: "Error occured", message: error.localizedDescription, alertTitle: "OK") { (action) in
                            self.emailTextField.text = ""
                            self.passwordTextField.text = ""
                            self.repasswordTextField.text = ""
                            self.userNameTextField.text = ""
                        }
                    } else {
                        self.db.collection(Constant.FireStore.users).addDocument(data: [Constant.FireStore.userName: userName, Constant.FireStore.uid: authResult!.user.uid]) { (error) in
                            if let error = error {
                                print(error)
                            } else {
                                if let currentUser = Auth.auth().currentUser?.createProfileChangeRequest() {
                                    currentUser.displayName = userName
                                    currentUser.commitChanges { (error) in
                                        if let error = error {
                                            print(error)
                                        } else {
                                            if let user = Auth.auth().currentUser {
                                                self.uid = user.uid
                                                self.performSegue(withIdentifier: Constant.Segue.signupSegue, sender: self)
                                                print("sign up success!")
                                                print(currentUser.displayName!)
                                            }
                                        }
                                    }
                                }
                            }
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
     2. 確保passwordTextField/repasswordTextField值是相同的
     */
    func validateTextField() -> String? {
        // Check all textFields are filled in, 檢查所有的textField是否都有輸入
        if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            repasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            userNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill in all fields."
        }
        // Check wether repassword is same as password, 檢查重新輸入密碼是否與密碼一致
        if repasswordTextField.text != passwordTextField.text {
            return "Password do not match, please enter password again."
        }
        return nil
    }
    
    func transitionToMainPage() {
        let mainPageViewController = storyboard?.instantiateViewController(withIdentifier: Constant.Storyboard.mainPage) as? MainPageViewController
        view.window?.rootViewController = mainPageViewController
    }
    
    // Question: Why don't need @escaping on action
    func popAlert(title: String, message: String, alertTitle: String, action: ((UIAlertAction) -> Void)?) {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alert = UIAlertAction(title: alertTitle, style: .cancel, handler: action)
        controller.addAction(alert)
        present(controller, animated: true, completion: nil)
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
