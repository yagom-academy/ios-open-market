import UIKit

protocol PickerDelegate: AnyObject {
    func addImage(with image: UIImage)
}

class ProductImagePickerController: UIImagePickerController {
    weak var pickerDelegate: PickerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }
}

extension ProductImagePickerController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            return
        }
        pickerDelegate?.addImage(with: image)
        self.dismiss(animated: true, completion: nil)
    }
}
