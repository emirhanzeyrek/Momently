import UIKit

class FeedTableViewCell: UITableViewCell {
    @IBOutlet weak var emailText: UILabel!
    @IBOutlet weak var userCommentText: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
