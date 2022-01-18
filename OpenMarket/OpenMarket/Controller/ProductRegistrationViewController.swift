import UIKit

class ProductRegistrationViewController: UIViewController, UINavigationControllerDelegate {
    private let imagePickerController = UIImagePickerController()
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpImagePicker()
    }
    
    private func setUpImagePicker() {
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
    }
    
    @IBAction func touchUpInsideAddButton(_ sender: UIButton) {
        present(imagePickerController, animated: true, completion: nil)
    }
}

extension ProductRegistrationViewController: UIImagePickerControllerDelegate {
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        var image: UIImage? = nil
        if let newImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            image = newImage
        }
        imageView.image = image
        picker.dismiss(animated: true, completion: nil)
    }
}
