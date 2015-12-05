//
//  JSON.swift
//  Boppl
//
//  Created by Davide De Franceschi on 05/12/2015.
//  Copyright © 2015 Boppl Ltd. All rights reserved.
//

import Foundation

//MARK: Foundation typealiases
public typealias FoundationJSONArray = [NSObject]
public typealias FoundationJSONObject = [String: NSObject]

//MARK: enum declaration
public enum JSON {
	case NullValue
	case BooleanValue(Bool)
	case NumberValue(NSDecimal)
	case StringValue(String)
	case ArrayValue([JSON])
	case ObjectValue([String: JSON])
}

//MARK: Errors
extension JSON {
	public enum Error: ErrorType {
		case ParsingError
	}
}



//MARK: Printables
private let tabCharacter: Character = "\t"
private func indentationOfLevel(indentationLevel: UInt) -> String { return String(count: Int(indentationLevel), repeatedValue: tabCharacter) }
extension JSON: CustomStringConvertible {
	public var description: String {
		switch self {
		case .NullValue: return "null"
		case .BooleanValue(let value): return value ? "true" : "false"
		case .NumberValue(let value): return "\(value)"
		case .StringValue(let value): return "\"\(value)\""
		case .ArrayValue(let value): return "[" + value.map({ "\($0)" }).joinWithSeparator(",") + "]"
		case .ObjectValue(let value): return "{" + value.sort({ $0.0 < $1.0 }).map({ "\"\($0)\":\($1)" }).joinWithSeparator(",") + "}"
		}
	}
}
extension JSON: CustomDebugStringConvertible {
	private func debugDescriptionWithIndentationLevel(indentationLevel: UInt) -> String {
		switch self {
		case .ArrayValue(let value):
			if value.isEmpty {
				return "[]"
			}
			return "[\n" + value.map({
				"\(indentationOfLevel(indentationLevel + 1))\($0.debugDescriptionWithIndentationLevel(indentationLevel + 1))"
				}).joinWithSeparator(",\n") + "\n\(indentationOfLevel(indentationLevel))]"
		case .ObjectValue(let value):
			if value.isEmpty {
				return "{}"
			}
			let sortedValue = value.sort({ $0.0 < $1.0 })
			return "{\n" + sortedValue.map({
				"\(indentationOfLevel(indentationLevel + 1))\"\($0)\": \($1.debugDescriptionWithIndentationLevel(indentationLevel + 1))"
				}).joinWithSeparator(",\n") + "\n\(indentationOfLevel(indentationLevel))}"
		default: return description
		}
	}
	public var debugDescription: String { return debugDescriptionWithIndentationLevel(0) }
}

//MARK: LiteralConvertibles
extension JSON: NilLiteralConvertible {
	public init(nilLiteral: ()) { self = NullValue }
}
extension JSON: BooleanLiteralConvertible {
	public init(booleanLiteral value: BooleanLiteralType) { self = BooleanValue(value)	}
}
extension JSON: IntegerLiteralConvertible, FloatLiteralConvertible {
	public init(integerLiteral value: IntegerLiteralType) { self = NumberValue(NSDecimal(integerLiteral: value)) }
	public init(floatLiteral value: FloatLiteralType) { self = NumberValue(NSDecimal(floatLiteral: value)) }
}
extension JSON: StringLiteralConvertible {
	public init(unicodeScalarLiteral value: Character) { self = StringValue(String(value)) }
	public init(extendedGraphemeClusterLiteral value: Character) { self = StringValue(String(value)) }
	public init(stringLiteral value: StringLiteralType) { self = StringValue(value) }
}
extension JSON: ArrayLiteralConvertible {
	public init(arrayLiteral elements: JSON...) { self = ArrayValue(elements) }
}
extension JSON: DictionaryLiteralConvertible {
	public init(dictionaryLiteral elements: (String, JSON)...) {
		var dictionary = [String: JSON](minimumCapacity: elements.count)
		for keyAndValue in elements {
			dictionary[keyAndValue.0] = keyAndValue.1
		}
		self = ObjectValue(dictionary)
	}
}

//MARK: init from Foundation types
extension NSNumber {
	private var numberType: CFNumberType { return CFNumberGetType(self) }
	private var couldBeJSONBoolean: Bool {
		return numberType == .SInt8Type || numberType == .CharType
	}
	private var couldBeJSONNumber: Bool {
		return (numberType == .DoubleType || numberType == .Float32Type || numberType == .Float64Type || numberType == .SInt32Type || numberType == .SInt64Type) && doubleValue.isFinite
	}
}
extension JSON {
	public enum FoundationBridgingError: ErrorType {
		case NSNumberNotAJSONBoolean(number: NSNumber)
		case NSNumberNotAJSONNumber(number: NSNumber)
		case NSDictionaryKeysNotAllStrings(dictionary: NSDictionary)
		case ObjectNotBridgeable(object: AnyObject)
	}
	
	public init(foundationNil value: NSNull) {
		self = NullValue
	}
	public init(foundationBoolean value: NSNumber) throws {
		guard value.couldBeJSONBoolean else { throw FoundationBridgingError.NSNumberNotAJSONBoolean(number: value) }
		self = BooleanValue(value.boolValue)
	}
	public init(foundationNumber value: NSNumber) throws {
		guard value.couldBeJSONNumber else { throw FoundationBridgingError.NSNumberNotAJSONNumber(number: value) }
		self = NumberValue(value.decimalValue)
	}
	public init(foundationString value: NSString) {
		self = StringValue(value as String)
	}
	public init(foundationArray value: NSArray) throws {
		var convertedArray: [JSON] = []
		for foundationObject in value {
			let convertedObject = try JSON(foundationObject: foundationObject)
			convertedArray.append(convertedObject)
		}
		self = ArrayValue(convertedArray)
	}
	public init(foundationDictionary value: NSDictionary) throws {
		var convertedDictionary: [String: JSON] = [:]
		for (foundationKey, foundationObject) in value {
			guard let key = foundationKey as? String else { throw FoundationBridgingError.NSDictionaryKeysNotAllStrings(dictionary: value) }
			let value = try JSON(foundationObject: foundationObject)
			convertedDictionary.updateValue(value, forKey: key)
		}
		self = ObjectValue(convertedDictionary)
	}
	public init(foundationObject value: AnyObject) throws {
		switch value {
		case let null as NSNull: self.init(foundationNil: null)
		case let boolean as NSNumber where boolean.couldBeJSONBoolean: try self.init(foundationBoolean: boolean)
		case let number as NSNumber where number.couldBeJSONNumber: try self.init(foundationNumber: number)
		case let string as NSString: self.init(foundationString: string)
		case let array as NSArray: try self.init(foundationArray: array)
		case let dictionary as NSDictionary: try self.init(foundationDictionary: dictionary)
		default: throw FoundationBridgingError.ObjectNotBridgeable(object: value)
		}
	}
}

//MARK: properties for Swift native types
extension JSON {
	public var asBool: Bool? {
		switch self {
		case .BooleanValue(let boolean): return boolean
		default: return nil
		}
	}
	public var asDecimal: NSDecimal? {
		switch self {
		case .NumberValue(let number): return number
		default: return nil
		}
	}
	public var asInt: Int? { return asDecimal?.asInt }
	public var asUInt: UInt? { return asDecimal?.asUInt }
	public var asDouble: Double? { return asDecimal?.asDouble }
	public var asString: String? {
		switch self {
		case .StringValue(let string): return string
		default: return nil
		}
	}
	public var asArray: [JSON]? {
		switch self {
		case .ArrayValue(let array): return array
		default: return nil
		}
	}
	public var asDictionary: [String: JSON]? {
		switch self {
		case .ObjectValue(let object): return object
		default: return nil
		}
	}
}

//MARK: subscripts
extension JSON {
	public subscript(arrayIndex: Int) -> JSON? {
		switch self {
		case .ArrayValue(let array): return arrayIndex < array.count ? array[arrayIndex] : nil
		default: return nil
		}
	}
	public subscript(objectKey: String) -> JSON? {
		switch self {
		case .ObjectValue(let object): return object[objectKey]
		default: return nil
		}
	}
}

//MARK: String en/decoding
extension JSON {
	public init(decodedFromData data: NSData) throws {
		let decodedObject: AnyObject = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
		try self.init(foundationObject: decodedObject)
	}
	public init(decodedFromString string: String, usingEncoding encoding: NSStringEncoding = NSUTF8StringEncoding) throws {
		let data = string.dataUsingEncoding(encoding)!
		try self.init(decodedFromData: data)
	}
	public func encodeToString() -> String {
		return description
	}
	public func encodeToData(encoding: NSStringEncoding = NSUTF8StringEncoding) -> NSData {
		return encodeToString().dataUsingEncoding(encoding)!
	}
}

//MARK: Model en/decoding
public protocol DataDecodable {
	init(decodeFromData data: NSData) throws
}

public protocol JSONDecodable: DataDecodable {
	init(decodeFromJSON json: JSON) throws
}
extension JSONDecodable {
	public init(decodeFromData data: NSData) throws {
		let json = try JSON(decodedFromData: data)
		try self.init(decodeFromJSON: json)
	}
}
extension JSON {
	public enum ArrayParsingError: ErrorType {
		case ElementNotDecodableType, NotAnArray
	}
}
extension Array: JSONDecodable {
	public init(decodeFromJSON json: JSON) throws {
		guard let DecodableElement = Element.self as? JSONDecodable.Type else { throw JSON.ArrayParsingError.ElementNotDecodableType }
		guard let jsonArray = json.asArray else { throw JSON.ArrayParsingError.NotAnArray }
		self = try jsonArray.flatMap({ try DecodableElement.init(decodeFromJSON: $0) as? Element })
	}
}

public protocol DataEncodable {
	func encodedData() -> NSData
}
public protocol JSONEncodable: DataEncodable {
	func encodedJSON() -> JSON
}
extension JSONEncodable {
	func encodedData() -> NSData {
		return encodedJSON().encodeToData()
	}
}
