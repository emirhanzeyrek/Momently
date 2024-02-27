import UIKit
import FirebaseCore
import Firebase
import FirebaseAuth

class ViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var backgroundImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextField.isSecureTextEntry = true
    }
    
    @IBAction func logInTiklandi(_ sender: Any) {
        if emailTextField.text != "" && passwordTextField.text != "" {
            Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) {
                (authDataResult, error) in
                if error != nil {
                    self.ErrorMessage(titleInput: "Error!", messageInput: error?.localizedDescription ??
                                      "Error, Please Try Again.")
                } else {
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
        } else {
            self.ErrorMessage(titleInput: "Error!", messageInput: "Enter Email and Password.")
        }
    }
    
    @IBAction func signUpTiklandi(_ sender: Any) {
        if emailTextField.text != "" && passwordTextField.text != "" {
            //Register
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (authDataResult, error) in
                if error != nil {
                    self.ErrorMessage(titleInput: "Error!", messageInput: error?.localizedDescription ??
                                      "Error, Please Try Again.")
                } else {
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
            
        } else {
            ErrorMessage(titleInput: "Error!", messageInput: "Enter Email and Password.")
        }
    }
    func ErrorMessage(titleInput: String, messageInput: String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
}

