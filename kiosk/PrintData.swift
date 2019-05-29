
import Foundation

public enum TemplateError: Swift.Error {
    public typealias RawValue = Data
    
    case FileNotFound
    case FileDataToStringConversion
    case StringToDataConversion
}

public struct PrintData {
    
    public let dictionary: [String: String]
    public let filePath: String
    
    public init(dictionary: [String: String], filePath: String) {
        self.dictionary = dictionary
        self.filePath = filePath
    }
    
    func rawData() throws -> NSData {
        guard let fileData = FileManager.default.contents(atPath: filePath) else {
            throw TemplateError.FileNotFound
        }
        guard let fileDataString = NSMutableString(data: fileData, encoding: String.Encoding.utf8.rawValue) else {
            throw TemplateError.FileDataToStringConversion
        }
        
        for (key, value) in dictionary {
            fileDataString.replaceOccurrences(of: key, with: value, options: .caseInsensitive, range: NSMakeRange(0, fileDataString.length))
        }
        
        guard let unparsedData = fileDataString.data(using: String.Encoding.utf8.rawValue) else {
            throw TemplateError.StringToDataConversion
        }
        
        let parser = TemplateParser()
        let parsedData = parser.parse(data: unparsedData as NSData)
        
        return parsedData
    }
    
}
