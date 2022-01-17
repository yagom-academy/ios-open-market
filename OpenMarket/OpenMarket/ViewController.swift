import UIKit

class ViewController: UIViewController {
    enum Section {
        case main
    }
    
    @IBOutlet weak var segment: SegmentedControl!
    @IBOutlet weak var listCollectionView: UICollectionView!
    @IBOutlet weak var gridCollectionView: UICollectionView!
    
    var productList = [ProductInformation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setSegmentedControl()
    }
    
    func setSegmentedControl() {
        self.navigationItem.titleView = segment
        segment.setUpUI()
    }
    
    @IBAction func changeView(_ sender: SegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            listCollectionView.isHidden = false
            gridCollectionView.isHidden = true
        case 1:
            listCollectionView.isHidden = true
            gridCollectionView.isHidden = false
        default:
            break
        }
    }
    
    func getData() {
        let api = APIManager()
        api.requestProductList(pageNumber: 1, itemsPerPage: 20) { result in
            switch result {
            case .success(let data):
                self.productList = data.pages
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension ViewController {
    
}
