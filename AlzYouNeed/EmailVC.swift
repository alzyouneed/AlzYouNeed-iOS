//
//  EmailVC.swift
//  AlzYouNeed
//
//  Created by Connor Wybranowski on 5/19/17.
//  Copyright © 2017 Alz You Need. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class EmailVC: UIViewController, UITextFieldDelegate {

    @IBOutlet var emailTextField: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet var passwordTextField: SkyFloatingLabelTextField!
    @IBOutlet var confirmPasswordTextField: SkyFloatingLabelTextField!
    
    @IBOutlet var signUpButton: UIButton!
    @IBOutlet var signUpButtonBottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(EmailVC.keyboardWillShow(sender:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(EmailVC.keyboardWillHide(sender:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        validateFields()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupView() {
        setupEmailTextField()
        setupPasswordTextField()
        setupConfirmPasswordTextField()
    }
    
    func setupEmailTextField() {
        emailTextField.font = UIFont(name: "OpenSans", size: 20)
        emailTextField.placeholder = "Email address"
        emailTextField.title = "Email"
        emailTextField.textColor = UIColor.black
        emailTextField.tintColor = UIColor(hex: "7d80da")
        emailTextField.lineColor = UIColor.lightGray
        emailTextField.iconFont = UIFont(name: "FontAwesome", size: 14)
        emailTextField.iconText = String.fontAwesomeIcon(name: .envelope)
        emailTextField.iconMarginBottom = -3
        emailTextField.selectedIconColor = UIColor(hex: "7d80da")
        
        emailTextField.selectedTitleColor = UIColor(hex: "7d80da")
        emailTextField.selectedLineColor = UIColor(hex: "7d80da")
        
        emailTextField.errorColor = UIColor(hex: "EF3054")
        emailTextField.delegate = self
        emailTextField.addTarget(self, action:#selector(EmailVC.editedEmailText), for:UIControlEvents.editingChanged)
        
        emailTextField.keyboardType = UIKeyboardType.emailAddress
        emailTextField.autocorrectionType = UITextAutocorrectionType.no
    }
    
    func setupPasswordTextField() {
        passwordTextField.font = UIFont(name: "OpenSans", size: 20)
        passwordTextField.placeholder = "Password"
        passwordTextField.title = "Password"
        passwordTextField.textColor = UIColor.black
        passwordTextField.tintColor = UIColor(hex: "7d80da")
        passwordTextField.lineColor = UIColor.lightGray
        
        passwordTextField.selectedTitleColor = UIColor(hex: "7d80da")
        passwordTextField.selectedLineColor = UIColor(hex: "7d80da")
        
        passwordTextField.delegate = self
        passwordTextField.addTarget(self, action:#selector(EmailVC.editedPasswordText), for:UIControlEvents.editingChanged)
        passwordTextField.autocorrectionType = UITextAutocorrectionType.no
    }
    
    func setupConfirmPasswordTextField() {
        confirmPasswordTextField.font = UIFont(name: "OpenSans", size: 20)
        confirmPasswordTextField.placeholder = "Confirm password"
        confirmPasswordTextField.title = "Confirm password"
        confirmPasswordTextField.textColor = UIColor.black
        confirmPasswordTextField.tintColor = UIColor(hex: "7d80da")
        confirmPasswordTextField.lineColor = UIColor.lightGray
        confirmPasswordTextField.selectedTitleColor = UIColor(hex: "7d80da")
        confirmPasswordTextField.selectedLineColor = UIColor(hex: "7d80da")
        
        confirmPasswordTextField.delegate = self
        confirmPasswordTextField.addTarget(self, action:#selector(EmailVC.editedConfirmPasswordText), for:UIControlEvents.editingChanged)
        confirmPasswordTextField.autocorrectionType = UITextAutocorrectionType.no
    }
    
    // MARK: - Adjusting keyboard
    func adjustingKeyboardHeight(show: Bool, notification: NSNotification) {
        let userInfo = notification.userInfo!
        let keyboardFrame: CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
        let animationCurveRawNSNumber = userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber
        let animationCurveRaw = animationCurveRawNSNumber.uintValue
        let animationCurve: UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
        let changeInHeight = (keyboardFrame.height) //* (show ? 1 : -1)
        
        UIView.performWithoutAnimation({
            self.emailTextField.layoutIfNeeded()
            self.passwordTextField.layoutIfNeeded()
            self.confirmPasswordTextField.layoutIfNeeded()
        })
        
        if show {
            // Change constraints here
            signUpButtonBottomConstraint.constant = changeInHeight
        } else {
            // Reset constraints here
            signUpButtonBottomConstraint.constant = 0
        }
        
        UIView.animate(withDuration: animationDuration, delay: 0, options: animationCurve, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func keyboardWillShow(sender: NSNotification) {
        adjustingKeyboardHeight(show: true, notification: sender)
    }
    
    func keyboardWillHide(sender: NSNotification) {
        adjustingKeyboardHeight(show: false, notification: sender)
    }
    
    // MARK: - TextField changes
    func editedEmailText() {
        if let text = emailTextField.text {
            if ((text.characters.count < 3  && text.characters.count > 0) || (!text.contains("@") && text.characters.count > 0)) {
                self.emailTextField.errorMessage = "Invalid email"
            } else {
                self.emailTextField.errorMessage = ""
            }
        }
        validateFields()
    }
    
    func editedPasswordText() {
        validateFields()
    }
    
    func editedConfirmPasswordText() {
        validateFields()
    }
    
    // MARK: - Validation
    func validateFields() {
        let passwordsMatch = passwordTextField.text == confirmPasswordTextField.text
        if !emailTextField.hasErrorMessage && (passwordTextField.text?.characters.count)! >= 6 && passwordsMatch {
            enableSignup(enable: true)
        } else {
            enableSignup(enable: false)
        }
    }
    
    func enableSignup(enable: Bool) {
        signUpButton.isEnabled = enable
        signUpButton.alpha = enable ? 1 : 0.6
    }
    
    // MARK: - Sign up
    @IBAction func signUpPressed(_ sender: UIButton) {
        // If Firebase sign-up succeeds then present next VC
        presentNextVC()
    }
    
    func presentNextVC() {
        print("Present NameVC")
        // Present next VC
        self.performSegue(withIdentifier: "emailToName", sender: self)
    }
    
    // MARK: - Cancel signup
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        // TODO: Delete partial user profile
        self.dismiss(animated: true, completion: nil)
        
//        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let onboardingVC: UINavigationController = storyboard.instantiateViewController(withIdentifier: "loginNav") as! UINavigationController
//        self.present(onboardingVC, animated: true, completion: nil)
    }
    

}
