import UIKit
import FirebaseCore
import Firebase
import FirebaseAuth

class SettingsViewController: UIViewController {
    @IBOutlet weak var backgroundImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func logOutTiklandi(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            performSegue(withIdentifier: "toViewController", sender: nil)
        } catch {
            print("Error, Exit Failed.")
        }
    }
}
