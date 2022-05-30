//
//  RegistrationView.swift
//  OpenMarket
//
//  Created by cathy, mmim.
//

import UIKit

final class RegistrationView: ProductUpdaterView {
  override init() {
    super.init()
    configureLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  let addImageButton: UIButton = {
    let button = UIButton()
    button.backgroundColor = .systemGray4
    button.setTitle(Constants.buttonTitle, for: .normal)
    button.setTitleColor(UIColor.systemBlue, for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()
  
  private let imageWithButtonStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.alignment = .fill
    stackView.distribution = .fill
    stackView.spacing = Constants.stackViewSpacing
    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()
  //MARK: - layout
  private func configureLayout() {
    imageScrollView.addSubview(imageWithButtonStackView)
    imageWithButtonStackView.addArrangedSubviews(imageStackView, addImageButton)
    priceStackView.addArrangedSubviews(priceTextField, currencySegmentedControl)
    textFieldStackView.addArrangedSubviews(nameTextField,
                                           priceStackView,
                                           discountedPriceTextField,
                                           stockTextField)
    totalStackView.addArrangedSubviews(imageScrollView, textFieldStackView, descriptionTextView)
    self.addSubview(totalStackView)
    
    NSLayoutConstraint.activate([
        totalStackView
        .leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.anchorSpacing),
       totalStackView
        .trailingAnchor
          .constraint(equalTo: self.trailingAnchor, constant: -Constants.anchorSpacing),
       totalStackView
        .topAnchor.constraint(equalTo: self.topAnchor, constant: Constants.anchorSpacing),
       totalStackView
        .bottomAnchor
          .constraint(equalTo: self.bottomAnchor, constant: -Constants.anchorSpacing),
       
       currencySegmentedControl
        .widthAnchor
        .constraint(equalTo: self.widthAnchor, multiplier: Constants.currencyWidthScale),
       
       addImageButton.widthAnchor.constraint(equalTo: addImageButton.heightAnchor),
       
       imageScrollView
        .heightAnchor
        .constraint(equalTo: self.heightAnchor, multiplier: Constants.scrollViewHeightScale),
       
       imageWithButtonStackView
        .leadingAnchor.constraint(equalTo: imageScrollView.contentLayoutGuide.leadingAnchor),
       imageWithButtonStackView
        .trailingAnchor.constraint(equalTo: imageScrollView.contentLayoutGuide.trailingAnchor),
       imageWithButtonStackView
        .topAnchor.constraint(equalTo: imageScrollView.contentLayoutGuide.topAnchor),
       imageWithButtonStackView
        .bottomAnchor.constraint(equalTo: imageScrollView.contentLayoutGuide.bottomAnchor),
       imageWithButtonStackView
        .heightAnchor.constraint(equalTo: imageScrollView.frameLayoutGuide.heightAnchor),
       descriptionTextView
        .heightAnchor
        .constraint(equalTo: self.heightAnchor, multiplier: Constants.textViewHeightScale)
      ])
  }
}
