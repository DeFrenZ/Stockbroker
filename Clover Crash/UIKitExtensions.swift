//
//  UIKitExtensions.swift
//  Clover Crash
//
//  Created by Davide De Franceschi on 05/12/2015.
//  Copyright © 2015 Boppl Ltd. All rights reserved.
//

import UIKit



//MARK: - UIColor
func interpolateRGBA(from from: UIColor, to: UIColor, by: CGFloat) -> UIColor {
	var fromRGBA = [CGFloat](count: 4, repeatedValue: 0.0)
	from.getRed(&fromRGBA[0], green: &fromRGBA[1], blue: &fromRGBA[2], alpha: &fromRGBA[3])
	
	var toRGBA = [CGFloat](count: 4, repeatedValue: 0.0)
	to.getRed(&toRGBA[0], green: &toRGBA[1], blue: &toRGBA[2], alpha: &toRGBA[3])
	
	let clampedBy = clamp(by, minimum: 0, maximum: 1)
	
	let interpolatedRGBA = zip(fromRGBA, toRGBA).map { $0 + ($1 - $0) * clampedBy }
	
	return UIColor(red:	interpolatedRGBA[0], green: interpolatedRGBA[1], blue: interpolatedRGBA[2],	alpha: interpolatedRGBA[3])
}
enum UIColorParsingError: ErrorType {
	case DoesNotStartWithHash, NotAnHexadecimalString, WrongNumberOfCharacters, CouldNotConvertToInteger
}
extension UIColor {
	convenience init(hashNotation: String) throws {
		guard hashNotation.hasPrefix("#") else { throw UIColorParsingError.DoesNotStartWithHash }
		
		let hexString = String(hashNotation.characters.dropFirst())
		guard hexString.rangeOfCharacterFromSet(NSCharacterSet.hexadecimalCharacterSet().invertedSet) == nil else { throw UIColorParsingError.NotAnHexadecimalString }
		
		var colorHex = UInt32()
		guard NSScanner(string: hexString).scanHexInt(&colorHex) else { throw UIColorParsingError.CouldNotConvertToInteger }
		
		let r, g, b, a: UInt32
		switch hexString.characters.count {
		case 3: (r, g, b, a) = ((colorHex >>  8) * 0x11, ((colorHex >>  4) &  0xF) * 0x11,  (colorHex       &  0xF) * 0x11,                     0xFF)
		case 4: (r, g, b, a) = ((colorHex >> 12) * 0x11, ((colorHex >>  8) &  0xF) * 0x11, ((colorHex >> 4) &  0xF) * 0x11, (colorHex &  0xF) * 0x11)
		case 6: (r, g, b, a) = ((colorHex >> 16)       , ((colorHex >>  8) & 0xFF)       ,  (colorHex       & 0xFF)       ,                     0xFF)
		case 8: (r, g, b, a) = ((colorHex >> 24)       , ((colorHex >> 16) & 0xFF)       , ((colorHex >> 8) & 0xFF)       , (colorHex & 0xFF)       )
		default: throw UIColorParsingError.WrongNumberOfCharacters
		}
		
		let (red, green, blue, alpha) = (CGFloat(r) / 255, CGFloat(g) / 255, CGFloat(b) / 255, CGFloat(a) / 255)
		self.init(red: red, green: green, blue: blue, alpha: alpha)
	}
}
extension String {
	var toColor: UIColor? { return try? UIColor(hashNotation: self) }
}


//MARK: - UIResponder
extension UIResponder {
	func performActionOnResponderChain(action: Selector, withObject object: NSObject? = nil) -> Bool {
		guard let responder = targetForAction(action, withSender: object) else { return false }
		responder.performSelector(action, withObject: object)
		return true
	}
}

//MARK: - UIViewController
extension UIViewController {
	func updateUIWithBlock(block: () -> ()) {
		guard isViewLoaded() else { return }
		dispatch_sync_main(block)
	}
}
