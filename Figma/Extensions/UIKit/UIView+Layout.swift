import UIKit

extension UIView {
    

    // MARK: - Helpers
    @discardableResult func centerHorizontally(to layoutElement: LayoutElement, withOffset offset: CGFloat = 0) -> NSLayoutConstraint {
        setConstraintTranslationToFalse()
        return centerXAnchor.constraint(equalTo: layoutElement.centerXAnchor, constant: offset).activate()
    }
    
    @discardableResult func centerVertically(to layoutElement: LayoutElement, withOffset offset: CGFloat = 0) -> NSLayoutConstraint {
        setConstraintTranslationToFalse()
        return centerYAnchor.constraint(equalTo: layoutElement.centerYAnchor, constant: offset).activate()
    }
    
    @discardableResult func pinEdges(to layoutElement: LayoutElement, withOffset offset: CGFloat = 0) -> [NSLayoutConstraint] {
        setConstraintTranslationToFalse()
        return [
            pinTopEdge(to: layoutElement, withOffset: offset),
            pinBottomEdge(to: layoutElement, withOffset: -offset),
            pinLeadingEdge(to: layoutElement, withOffset: offset),
            pinTrailingEdge(to: layoutElement, withOffset: -offset)
        ]
    }
    
    @discardableResult func pinTopEdge(to layoutElement: LayoutElement, withOffset offset: CGFloat = 0) -> NSLayoutConstraint {
        setConstraintTranslationToFalse()
        return topAnchor.constraint(equalTo: layoutElement.topAnchor, constant: offset).activate()
    }
    
    @discardableResult func pinBottomEdge(to layoutElement: LayoutElement, withOffset offset: CGFloat = 0) -> NSLayoutConstraint {
        setConstraintTranslationToFalse()
        return bottomAnchor.constraint(equalTo: layoutElement.bottomAnchor, constant: offset).activate()
    }
    
    @discardableResult func pinLeadingEdgeToTrailingEdge(of layoutElement: LayoutElement, withOffset offset: CGFloat = 0) -> NSLayoutConstraint {
        setConstraintTranslationToFalse()
        return leadingAnchor.constraint(equalTo: layoutElement.trailingAnchor, constant: offset).activate()
    }
    
    @discardableResult func pinLeadingEdgeToTrailingEdge(lessThanOrEqualTo layoutElement: LayoutElement, withOffset offset: CGFloat = 0) -> NSLayoutConstraint {
        setConstraintTranslationToFalse()
        return leadingAnchor.constraint(lessThanOrEqualTo: layoutElement.trailingAnchor, constant: offset).activate()
    }
    
    @discardableResult func pinLeadingEdgeToTrailingEdge(graterThanOrEqualTo layoutElement: LayoutElement, withOffset offset: CGFloat = 0) -> NSLayoutConstraint {
        setConstraintTranslationToFalse()
        return leadingAnchor.constraint(greaterThanOrEqualTo: layoutElement.trailingAnchor, constant: offset).activate()
    }
    
    @discardableResult func pinLeadingAndTrailingEdges(to layoutElement: LayoutElement, withOffset offset: CGFloat = 0) -> [NSLayoutConstraint] {
        setConstraintTranslationToFalse()
        return [
            pinLeadingEdge(to: layoutElement, withOffset: offset),
            pinTrailingEdge(to: layoutElement, withOffset: -offset)
        ]
    }
    
    @discardableResult func pinTrailingEdge(to layoutElement: LayoutElement, withOffset offset: CGFloat = 0) -> NSLayoutConstraint {
        setConstraintTranslationToFalse()
        return trailingAnchor.constraint(equalTo: layoutElement.trailingAnchor, constant: offset).activate()
    }
    
    func setHorizontalContentHugging(to priority: UILayoutPriority = .defaultLow, withOffset offset: Float = 0) {
        setConstraintTranslationToFalse()
        setContentHuggingPriority(UILayoutPriority(priority.rawValue + offset), for: .horizontal)
    }
    
    @discardableResult func pinLeadingEdge(to layoutElement: LayoutElement, withOffset offset: CGFloat = 0) -> NSLayoutConstraint {
        setConstraintTranslationToFalse()
        return leadingAnchor.constraint(equalTo: layoutElement.leadingAnchor, constant: offset).activate()
    }
    
    @discardableResult func pinTrailingEdgeToLeading(of layoutElement: LayoutElement, withOffset offset: CGFloat = 0) -> NSLayoutConstraint {
        setConstraintTranslationToFalse()
        return trailingAnchor.constraint(equalTo: layoutElement.leadingAnchor, constant: offset).activate()
    }
    
    @discardableResult func pinTopEdgeToBottom(of layoutElement: LayoutElement, withOffset offset: CGFloat = 0) -> NSLayoutConstraint {
        setConstraintTranslationToFalse()
        return topAnchor.constraint(equalTo: layoutElement.bottomAnchor, constant: offset).activate()
    }
    
    @discardableResult func pinBottomEdge(lessThanOrEqualTo layoutElement: LayoutElement, withOffset offset: CGFloat = 0) -> NSLayoutConstraint {
        setConstraintTranslationToFalse()
        return bottomAnchor.constraint(lessThanOrEqualTo: layoutElement.bottomAnchor, constant: offset).activate()
    }
    
    @discardableResult func pinTopAndBottomEdge(to layoutElement: LayoutElement, withOffset offset: CGFloat = 0) -> [NSLayoutConstraint] {
        setConstraintTranslationToFalse()
        return [
            pinTopEdge(to: layoutElement, withOffset: offset),
            pinBottomEdge(to: layoutElement, withOffset: -offset)
        ]
    }
    
    @discardableResult func pinSize(to size: CGSize) -> [NSLayoutConstraint] {
        setConstraintTranslationToFalse()
        return [
            pinWidth(to: size.width).activate(),
            pinHeight(to: size.height).activate()
        ]
    }
    
    @discardableResult func pinHeight(to height: CGFloat) -> NSLayoutConstraint {
        setConstraintTranslationToFalse()
        return heightAnchor.constraint(equalToConstant: height).activate()
    }
    
    @discardableResult func pinWidth(to width: CGFloat) -> NSLayoutConstraint {
        setConstraintTranslationToFalse()
        return widthAnchor.constraint(equalToConstant: width).activate()
    }
    
    private func setConstraintTranslationToFalse() {
        guard translatesAutoresizingMaskIntoConstraints else { return }
        translatesAutoresizingMaskIntoConstraints = false
    }
}

public protocol LayoutElement {
    var leadingAnchor: NSLayoutXAxisAnchor { get }
    var trailingAnchor: NSLayoutXAxisAnchor { get }
    var leftAnchor: NSLayoutXAxisAnchor { get }
    var rightAnchor: NSLayoutXAxisAnchor { get }
    var topAnchor: NSLayoutYAxisAnchor { get }
    var bottomAnchor: NSLayoutYAxisAnchor { get }
    var widthAnchor: NSLayoutDimension { get }
    var heightAnchor: NSLayoutDimension { get }
    var centerXAnchor: NSLayoutXAxisAnchor { get }
    var centerYAnchor: NSLayoutYAxisAnchor { get }
}

extension UIView: LayoutElement { }
extension UILayoutGuide: LayoutElement { }
public extension NSLayoutConstraint {
    
    /// Activates the receiver and returns it.
    @discardableResult func activate() -> NSLayoutConstraint {
        if !isActive {
            isActive = true
        }
        
        return self
    }
}
