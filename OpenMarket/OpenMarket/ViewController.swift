import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var segment: SegmentedControl!
    @IBOutlet weak var listCollectionView: UICollectionView!
    @IBOutlet weak var gridCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setSegmentedControl()
        setUpListCollectionView()
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
}

extension ViewController {
    func setUpListCollectionView() {
        // 뷰 전환 테스트
        listCollectionView.backgroundColor = .red
        gridCollectionView.backgroundColor = .blue
    }
}
