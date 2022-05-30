//
//  EditView.swift
//  OpenMarket
//
//  Created by cathy, mmim.
//

import UIKit

final class EditingView: ProductUpdaterView {
  override init() {
    super.init()
    configureLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  //MARK: - layout
  private func configureLayout() {
    imageScrollView.addSubview(imageStackView)
    priceStackView.addArrangedSubviews(priceTextField, currencySegmentedControl)
    textFieldStackView.addArrangedSubviews(nameTextField,
                                           priceStackView,
                                           discountedPriceTextField,
                                           stockTextField)
    totalStackView.addArrangedSubviews(imageScrollView, textFieldStackView, descriptionTextView)
    self.addSubview(totalStackView)
    
    NSLayoutConstraint.activate(
      [totalStackView
        .leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.anchorSpacing),
       totalStackView
        .trailingAnchor
        .constraint(equalTo: self.trailingAnchor, constant: -Constants.anchorSpacing),
       totalStackView
        .topAnchor.constraint(equalTo: self.topAnchor, constant: Constants.anchorSpacing),
       totalStackView
        .bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -Constants.anchorSpacing),
       
       currencySegmentedControl
        .widthAnchor
        .constraint(equalTo: self.widthAnchor, multiplier: Constants.currencyWidthScale),
       
       
       imageScrollView
        .heightAnchor
        .constraint(equalTo: self.heightAnchor, multiplier: Constants.scrollViewHeightScale),
       
       imageStackView
        .leadingAnchor.constraint(equalTo: imageScrollView.contentLayoutGuide.leadingAnchor),
       imageStackView
        .trailingAnchor.constraint(equalTo: imageScrollView.contentLayoutGuide.trailingAnchor),
       imageStackView
        .topAnchor.constraint(equalTo: imageScrollView.contentLayoutGuide.topAnchor),
       imageStackView
        .bottomAnchor.constraint(equalTo: imageScrollView.contentLayoutGuide.bottomAnchor),
       imageStackView
        .heightAnchor.constraint(equalTo: imageScrollView.frameLayoutGuide.heightAnchor),
       descriptionTextView
        .heightAnchor
        .constraint(equalTo: self.heightAnchor, multiplier: Constants.textViewHeightScale)
      ])
  }
  
  func displayInformation(of detailProduct: DetailProduct) {
    self.nameTextField.text = detailProduct.name
    self.priceTextField.text = detailProduct.price?.description
    self.discountedPriceTextField.text = detailProduct.discountedPrice?.description
    self.stockTextField.text = detailProduct.stock?.description
    self.descriptionTextView.text = detailProduct.description
    switch detailProduct.currency {
    case Currency.won.description:
      self.currencySegmentedControl.selectedSegmentIndex = Currency.won.rawValue
    case Currency.dollar.description:
      self.currencySegmentedControl.selectedSegmentIndex = Currency.dollar.rawValue
    default:
      self.currencySegmentedControl.selectedSegmentIndex = Currency.won.rawValue
    }
  }
}
