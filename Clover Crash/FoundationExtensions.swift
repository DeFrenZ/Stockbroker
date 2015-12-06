//
//  FoundationExtensions.swift
//  Clover Crash
//
//  Created by Davide De Franceschi on 05/12/2015.
//  Copyright © 2015 Boppl Ltd. All rights reserved.
//

import Foundation
import CoreGraphics



//MARK: - NSDecimal
extension NSDecimal: Equatable {}
public func ==(var lhs: NSDecimal, var rhs: NSDecimal) -> Bool {
	return NSDecimalCompare(&lhs, &rhs) == .OrderedSame
}

extension NSDecimal: Comparable {}
public func <(var lhs: NSDecimal, var rhs: NSDecimal) -> Bool {
	return NSDecimalCompare(&lhs, &rhs) == .OrderedAscending
}

extension NSDecimal: CustomStringConvertible {
	public var description: String {
		var printed = self
		return NSDecimalString(&printed, nil)
	}
}

extension NSDecimal: IntegerLiteralConvertible {
	public init(integerLiteral value: IntegerLiteralType) {
		self = NSDecimalNumber(integerLiteral: value).decimalValue
	}
}
extension NSDecimal: FloatLiteralConvertible {
	public init(floatLiteral value: FloatLiteralType) {
		self = NSDecimalNumber(floatLiteral: value).decimalValue
	}
}

public prefix func -(value: NSDecimal) -> NSDecimal {
	return value * (-1)
}
public func + (var lhs: NSDecimal, var rhs: NSDecimal) -> NSDecimal {
	var result = NSDecimal()
	NSDecimalAdd(&result, &lhs, &rhs, .RoundPlain)
	return result
}
public func * (var lhs: NSDecimal, var rhs: NSDecimal) -> NSDecimal {
	var result = NSDecimal()
	NSDecimalMultiply(&result, &lhs, &rhs, .RoundPlain)
	return result
}
public func / (var lhs: NSDecimal, var rhs: NSDecimal) -> NSDecimal {
	var result = NSDecimal()
	NSDecimalDivide(&result, &lhs, &rhs, .RoundPlain)
	return result
}

extension NSDecimal {
	public var asInt: Int { return NSDecimalNumber(decimal: self).integerValue }
	public var asUInt: UInt { return NSDecimalNumber(decimal: self).unsignedLongValue }
	public var asDouble: Double { return NSDecimalNumber(decimal: self).doubleValue }
	public var asCGFloat: CGFloat { return CGFloat(asDouble) }
}

//MARK: - NSData
extension NSData {
	var isEmpty: Bool {
		return length == 0
	}
}

//MARK: - NSCharacterSet
extension NSCharacterSet {
	private static let _hexadecimalCharacterSet = NSCharacterSet(charactersInString: "0123456789aAbBcCdDeEfF")
	public class func hexadecimalCharacterSet() -> NSCharacterSet {
		return _hexadecimalCharacterSet
	}
}
