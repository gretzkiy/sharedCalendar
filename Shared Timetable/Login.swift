//
//  Login.swift
//  Shared Timetable
//
//  Created by Даниил Пес Кудрявцев on 28/01/2018.
//  Copyright © 2018 Даниил Пес Кудрявцев. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    
    
    @IBOutlet weak var logInBarButtonItem: UIBarButtonItem!
    
    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var labelConstraint: NSLayoutConstraint!
    @IBOutlet weak var warningConstraint: NSLayoutConstraint!
    @IBOutlet weak var loginConstraint: NSLayoutConstraint!
    @IBOutlet weak var passwordConstraint: NSLayoutConstraint!
    @IBOutlet weak var registerConstraint: NSLayoutConstraint!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        let screenHeight = view.frame.height
        labelConstraint.constant = screenHeight/10
        warningConstraint.constant = screenHeight/25
        loginConstraint.constant = screenHeight/20
        passwordConstraint.constant = screenHeight/20
        registerConstraint.constant = screenHeight/5
        
        logInBarButtonItem.isEnabled = false
        loginTextField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        
        //for function textFieldShouldReturn
        self.loginTextField.delegate = self
        self.passwordTextField.delegate = self
    }
    
    //Hides keyboard while tapping outside the text field
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    //Hides keyboard when "return" button pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return (true)
    }
    
    func editingChanged(_ textField: UITextField) {
        guard
            let login = loginTextField.text, !login.isEmpty,
            let password = passwordTextField.text, !password.isEmpty
        else {
                self.logInBarButtonItem.isEnabled = false
                return
        }
        logInBarButtonItem.isEnabled = true
    }
    

    @IBAction func loginAction(_ sender: Any) {
        let login = loginTextField.text!
        let password = passwordTextField.text!
        let postString = "login=\(login)&password=\(password)"
        let myURL = URL(string: "http://188.166.110.14/signin?\(postString)")!
        let session = URLSession(configuration: URLSessionConfiguration.default)
        session.dataTask(with: myURL) { (_, response, error) in
            DispatchQueue.main.async {
                guard let response = response as? HTTPURLResponse else {
                    // Error handle
                    self.warningLabel.text = "No internet connection"
                    self.warningLabel.textColor = UIColor.red
                    return
                }
                let status = response.statusCode
                if let error = error {
                    print(error.localizedDescription)
                }
                print("response status: \(status)")
                switch status {
                case 202:
                    //установка UserDefaults
                    let defaults = UserDefaults.standard
                    defaults.setValue(login, forKey: "login")
                    defaults.setValue(password, forKey: "password")
                    defaults.synchronize()
                    self.dismiss(animated: true, completion: nil)
                case 401:
                    self.warningLabel.text = "Wrong login or password"
                    self.warningLabel.textColor = UIColor.red
                default:
                    print("unknown status code")
                }
            }
        }.resume()
    }
    
    @IBAction func registerAction(_ sender: Any) {
        performSegue(withIdentifier: "register", sender: nil)
    }
    
    
    
}
