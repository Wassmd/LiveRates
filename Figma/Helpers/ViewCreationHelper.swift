import UIKit

enum ViewCreationHelper {
    
    // MARK: - Properties
    // MARK: Constants
    
    private enum Constants {
        static let iconBorderWidth: CGFloat = 7
        static let cornerRadius: CGFloat = 4
        static let labelMinimumScaleFactor: CGFloat = 0.5
        static let defaultFontSize: CGFloat = 17.0
    }
    
    
    // MARK: - Helpers
    
    static func createImageView(image: UIImage? = nil, tintColor: UIColor = .white, contentMode: UIView.ContentMode = .scaleAspectFit, clipsToBounds: Bool = true, backgroundColor: UIColor = .clear, isUserInteractionEnabled: Bool = false) -> UIImageView {
        let imageView = UIImageView()
        
        imageView.image = image
        imageView.contentMode = contentMode
        imageView.tintColor = tintColor
        imageView.clipsToBounds = clipsToBounds
        imageView.backgroundColor = backgroundColor
        imageView.isUserInteractionEnabled = isUserInteractionEnabled
        
        return imageView
    }
    
    static func createImageContaioner(
        borderColor: UIColor = .gray,
        borderWidth: CGFloat = Constants.iconBorderWidth,
        cornerRadius: CGFloat = Constants.cornerRadius,
        backgroudColor: UIColor = .clear) -> UIView {
        let view = UIView()
        view.layer.borderColor = borderColor.cgColor
        view.layer.borderWidth = borderWidth
        view.layer.cornerRadius = cornerRadius
        view.backgroundColor = backgroudColor
        
        return view
    }
    
    static func createLabel(text: String? = nil,
                                   font: UIFont = UIFont.systemFont(ofSize: Constants.defaultFontSize),
                                   textColor: UIColor = .black,
                                   height: CGFloat? = nil,
                                   textAlignment: NSTextAlignment = .left,
                                   numberOfLines: Int = 1,
                                   isUserInteractionEnabled: Bool = false,
                                   autoShrinkFont: Bool = false,
                                   autoTightening: Bool = false) -> UILabel {
        let label = UILabel()
        
        label.text = text
        label.textColor = textColor
        label.textAlignment = textAlignment
        label.font = font
        label.backgroundColor = .clear
        label.numberOfLines = numberOfLines
        label.isUserInteractionEnabled = isUserInteractionEnabled
        
        if autoShrinkFont {
            label.minimumScaleFactor = Constants.labelMinimumScaleFactor
            label.adjustsFontSizeToFitWidth = true
            label.lineBreakMode = .byTruncatingTail
        }
        
        label.allowsDefaultTighteningForTruncation = autoTightening
        
        return label
    }
    
    static func createAlertView(title: String?, message: String?, preferredStyle: UIAlertController.Style) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        alertController.view.tintColor = .black
        
        return alertController
    }
    
    public static func createImageButton(image: UIImage, titleFont: UIFont? = nil, highlightedImage: UIImage? = nil, width: CGFloat? = nil, height: CGFloat? = nil, buttonType: UIButton.ButtonType = .system, titleInsets: UIEdgeInsets = UIEdgeInsets.zero) -> UIButton {
        let button = UIButton(type: buttonType)
        
        if let width = width { button.pinWidth(to: width) }
        if let height = height { button.pinHeight(to: height) }
        if let titleFont = titleFont { button.titleLabel?.font = titleFont }
        
        button.titleEdgeInsets = titleInsets
        button.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        button.setImage(highlightedImage, for: .highlighted)
        return button
    }
}
