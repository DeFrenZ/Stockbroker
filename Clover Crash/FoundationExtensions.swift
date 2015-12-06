//
//  FoundationExtensions.swift
//  Clover Crash
//
//  Created by Davide De Franceschi on 05/12/2015.
//  Copyright © 2015 Boppl Ltd. All rights reserved.
//

import Foundation



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

public func +(var lhs: NSDecimal, var rhs: NSDecimal) -> NSDecimal {
	var result = NSDecimal()
	NSDecimalAdd(&result, &lhs, &rhs, .RoundPlain)
	return result
}
public func /(var lhs: NSDecimal, var rhs: NSDecimal) -> NSDecimal {
	var result = NSDecimal()
	NSDecimalDivide(&result, &lhs, &rhs, .RoundPlain)
	return result
}

extension NSDecimal {
	public var asInt: Int { return NSDecimalNumber(decimal: self).integerValue }
	public var asUInt: UInt { return NSDecimalNumber(decimal: self).unsignedLongValue }
	public var asDouble: Double { return NSDecimalNumber(decimal: self).doubleValue }
}

//MARK: - NSData
extension NSData {
	var isEmpty: Bool {
		return length == 0
	}
}
