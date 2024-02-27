import UIKit
import FirebaseCore
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var commentTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        imageView.addGestureRecognizer(gestureRecognizer)
    }
    @objc func selectImage() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func uploadTiklandi(_ sender: Any) {
        let storage = Storage.storage()
        let storageReference = storage.reference()
        let mediaFolder = storageReference.child("media")
        if let data = imageView.image?.jpegData(compressionQuality: 0.5) {
            let uuid = UUID().uuidString
            let imageReference = mediaFolder.child("\(uuid).jpg")
            imageReference.putData(data, metadata: nil) { (storageMetaData, error) in
                if error != nil {
                    self.ErrorMessageShow(title: "Error!", message: error?.localizedDescription ??
                                          "Error, Please Try Again.")
                } else {
                    imageReference.downloadURL { (url, error) in
                        if error == nil {
                            let imageUrl = url?.absoluteString
                            if let imageUrl = imageUrl {
                                let firestoreDatabase = Firestore.firestore()
                                let firestorePost = ["imageUrl": imageUrl,
                                                     "comment": self.commentTextField.text!,
                                                     "email": Auth.auth().currentUser!.email,
                                                     "date": FieldValue.serverTimestamp() ] as [String: Any]
                                firestoreDatabase.collection("Post").addDocument(data: firestorePost) {
                                    (error) in
                                    if error != nil {
                                        self.ErrorMessageShow(title: "Error!", message: error?.localizedDescription ?? "Error, Please Try Again.")
                                    } else {
                                        self.imageView.image = UIImage(named: "selectImage")
                                        self.commentTextField.text = ""
                                        self.tabBarController?.selectedIndex = 0
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    func ErrorMessageShow(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
}
