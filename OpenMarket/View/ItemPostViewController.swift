//
//  ItemPostViewController.swift
//  OpenMarket
//
//  Created by 최정민 on 2021/05/26.
//

import UIKit

class ItemPostViewController: UIViewController {
    
    @IBOutlet var imageCollectionView: UICollectionView!
    @IBOutlet var itemPostTitle: UITextField!
    @IBOutlet var currency: UITextField!
    @IBOutlet var price: UITextField!
    @IBOutlet var discountedPrice: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var descriptions: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
