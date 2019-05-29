
import Foundation

enum TemplateElement: String {
    case Print = "print"
    
    case AlignLeft = "left"
    case AlignCenter = "center"
    case AlignRight = "right"

    case NewLine = "newline"
    case Tab = "tab"
    
    case Bold = "bold"
    case Underline = "underline"
    case Upperline = "upperline"
    case Large = "large"
    case InvertColor = "invertcolor"

    case OpenDrawer1 = "opendrawer1"
    case OpenDrawer2 = "opendrawer2"
}

class TemplateParser: NSObject, XMLParserDelegate {
    
    private var parsedData = NSMutableData()
    
    func parse(data: NSData) -> NSData {
        parsedData = NSMutableData()
        
        let parser = XMLParser(data: data as Data)
        parser.delegate = self
        parser.parse()

        return parsedData
    }
    
    private func appendBytes(bytes: [Byte]?) {
        if let bytes = bytes {
            parsedData.append(bytes, length: bytes.count)
        }
    }
    
    private func appendDataFromString(string: String) {
        if let data = string.data(using: String.Encoding.ascii) {
            parsedData.append(data)
        }
    }
    
    // MARK: - NSXMLParserDelegate
    
    func parser(parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        let element = TemplateElement(rawValue: elementName)
        
        switch element! {
        case .AlignCenter:
            appendBytes(bytes: PrinterCommand.alignCenterCommand)
        case .AlignLeft:
            appendBytes(bytes: PrinterCommand.alignLeftCommand)
        case .AlignRight:
            appendBytes(bytes: PrinterCommand.alignRightCommand)
        case .Bold:
            appendBytes(bytes: PrinterCommand.boldStartCommand)
        case .InvertColor:
            appendBytes(bytes: PrinterCommand.invertedColorStartCommand)
        case .Large:
            appendBytes(bytes: PrinterCommand.largeTextStartCommand)
        case .NewLine:
            appendBytes(bytes: PrinterCommand.newLineCommand)
        case .OpenDrawer1:
            appendBytes(bytes: PrinterCommand.openDrawer1Command)
        case .OpenDrawer2:
            appendBytes(bytes: PrinterCommand.openDrawer2Command)
        case .Print:
            appendBytes(bytes: PrinterCommand.alignLeftCommand)
        case .Tab:
            appendBytes(bytes: PrinterCommand.tabCommand)
        case .Underline:
            appendBytes(bytes: PrinterCommand.underlineStartCommand)
        case .Upperline:
            appendBytes(bytes: PrinterCommand.upperlineStartCommand)
        }
    }
    
    func parser(parser: XMLParser, foundCharacters string: String) {
        appendDataFromString(string: string)
    }
    
    func parser(parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        let element = TemplateElement(rawValue: elementName)
        
        switch element! {
        case .Bold:
            appendBytes(bytes: PrinterCommand.boldEndCommand)
        case .InvertColor:
            appendBytes(bytes: PrinterCommand.invertedColorEndCommand)
        case .Large:
            appendBytes(bytes: PrinterCommand.largeTextEndCommand)
        case .Print:
            appendBytes(bytes: PrinterCommand.partialCutCommand)
        case .Underline:
            appendBytes(bytes: PrinterCommand.underlineEndCommand)
        case .Upperline:
            appendBytes(bytes: PrinterCommand.upperlineEndCommand)
        default:
            appendBytes(bytes: nil)
        }
    }
    
}
