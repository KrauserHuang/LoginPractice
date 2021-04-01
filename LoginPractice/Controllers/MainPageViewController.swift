//
//  MainPageViewController.swift
//  LoginPractice
//
//  Created by Tai Chin Huang on 2021/3/26.
//

import UIKit
import Firebase

class MainPageViewController: UIViewController {
    
    @IBOutlet weak var welcomeLabel: UILabel!
    
    let db = Firestore.firestore()
    var uid = ""
    var userName = ""
    var isUserLoggedIn = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        if let user = Auth.auth().currentUser {
        //            uid = user.uid
        //            getUserInfo(uid: uid)
        //        }
        loadUser()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Auth.auth().addStateDidChangeListener { (auth, user) in
            self.isUserLoggedIn = true
        }
    }
    
    @IBAction func logoutPressed(_ sender: UIButton) {
        // 畫面顯示怪怪的，再確認
        do {
            try Auth.auth().signOut()
            //            navigationController?.popToRootViewController(animated: true)
            var rootVC = self.presentingViewController
            while let parent = rootVC?.presentingViewController {
                rootVC = parent
            }
            rootVC?.dismiss(animated: true, completion: nil)
            print("logout success!")
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
//    func getUserInfo(uid: String) {
//        db.collection(Constant.FireStore.users).document(uid).addSnapshotListener { (documentSnapshot, error) in
//            guard let document = documentSnapshot else {
//                print("Error fetching document, \(error!)")
//                return
//            }
//            guard let data = document.data() else {
//                print("Document data was empty")
//                return
//            }
//            print("Current data: \(data)")
//        }
//    }
    
    func loadUser() {
        //        db.collection(Constant.FireStore.users).addSnapshotListener { (querySnapshot, error) in
        //            if let error = error {
        //                print("There was an issue retrieving data to Firestore. \(error)")
        //            } else {
        //                if let snapshotDocuments = querySnapshot?.documents {
        //                    for doc in snapshotDocuments {
        //                        print(doc.data())
        //                        let data = doc.data()
        //                        if let userName = data[Constant.FireStore.userName] as? String {
        //                            // label顯示速度有差，再確認
        //                            DispatchQueue.main.async {
        //                                self.welcomeLabel.text = "Welcome, \(userName)"
        //                            }
        //                        }
        //                    }
        //                }
        //            }
        //        }
        if let user = Auth.auth().currentUser {
            print("user: \(user)")
            uid = user.uid
            userName = user.displayName!
            DispatchQueue.main.async {
                self.welcomeLabel.text = "Welcome, \(self.userName)"
            }
        }
//        if let userInfo = Auth.auth().currentUser?.providerData {
//            
//        }
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
