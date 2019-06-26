import UIKit

extension UIImage {
    
    func resizeToFit(to scaledToSize: CGSize, scale: CGFloat = UIScreen.main.scale) -> UIImage {
        guard self.size != scaledToSize else { return self }
        
        let widthRatio  = scaledToSize.width  / self.size.width
        let heightRatio = scaledToSize.height / self.size.height
        
        let newSize = CGSize(width: size.width * widthRatio, height: size.height * heightRatio)
        let rect = CGRect(origin: .zero, size: newSize)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, scale)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage ?? self
    }
}
