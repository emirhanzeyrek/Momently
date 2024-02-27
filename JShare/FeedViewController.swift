import UIKit
import FirebaseCore
import Firebase
import FirebaseAuth
import FirebaseFirestore
import SDWebImage

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    var postArray = [Post]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        firebaseGetData()
    }
    func firebaseGetData(){
        let firestoreDatabase = Firestore.firestore()
        firestoreDatabase.collection("Post").order(by: "date", descending: true)
            .addSnapshotListener {
            (snapshot, error) in
            if error != nil {
                print(error?.localizedDescription)
            } else {
                if snapshot?.isEmpty != true && snapshot != nil {
                    self.postArray.removeAll(keepingCapacity: false)
                    for document in snapshot!.documents {
                        if let imageUrl = document.get("imageUrl") as? String {
                            if let comment = document.get("comment") as? String {
                                if let email = document.get("email") as? String {
                                    let post = Post(email: email, comment: comment, imageUrl: imageUrl)
                                    self.postArray.append(post)
                                }
                            }
                        }
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedTableViewCell
        cell.emailText.text = postArray[indexPath.row].email
        cell.userCommentText.text = postArray[indexPath.row].comment
        cell.postImageView.sd_setImage(with: URL(string: self.postArray[indexPath.row].imageUrl))
        return cell
    }
}
