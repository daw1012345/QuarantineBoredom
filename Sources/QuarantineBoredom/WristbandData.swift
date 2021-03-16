import Foundation

struct WristbandData
{
    private(set) var companyID: UInt16 = 0
    private(set) var protocolID: UInt8 = 0
    
    private(set) var modelID: UInt8 = 0
    private(set) var major: UInt16 = 0
    private(set) var minor: UInt16 = 0
    
    private(set) var txPower: UInt8 = 0
    
    private(set) var isCharging: Bool = false
    private(set) var batteryLevel: UInt8 = 0
    
    private(set) var isActivated: Bool = false
    
    private(set) var isStrapIntact: Bool = false
    private(set) var isStrapLocked: Bool = false

    
    public static func isWristband(manData buf: Data) -> Bool
    {
        return (buf[2] == 81) || (buf[2] == 84)
    }
    
    init(withManufacturerData buf: Data)
    {
        let _ = withUnsafeMutableBytes(of: &self.companyID, {buf.copyBytes(to: $0, from: 0..<2)})
        let _ = withUnsafeMutableBytes(of: &self.protocolID, {buf.copyBytes(to: $0, from: 2..<3)})
        let _ = withUnsafeMutableBytes(of: &self.modelID, {buf.copyBytes(to: $0, from: 3..<4)})
        let _ = withUnsafeMutableBytes(of: &self.major, {buf.copyBytes(to: $0, from: 4..<6)})
        
        self.major = self.major.byteSwapped
        let _ = withUnsafeMutableBytes(of: &self.minor, {buf.copyBytes(to: $0, from: 6..<8)})
        self.minor = self.minor.byteSwapped
        
        let _ = withUnsafeMutableBytes(of: &self.txPower, {buf.copyBytes(to: $0, from: 8..<9)})
        
        var bitwiseDataEncodedInfo: UInt16 = 0
        
        let _ = withUnsafeMutableBytes(of: &bitwiseDataEncodedInfo, {buf.copyBytes(to: $0, from: 9..<11)})
        bitwiseDataEncodedInfo = bitwiseDataEncodedInfo.byteSwapped
        
        self.isCharging = UInt8(bitwiseDataEncodedInfo >> 15 & 1) == 1
        self.batteryLevel = UInt8(bitwiseDataEncodedInfo >> 8 & 127)
        
        self.isActivated = UInt8(bitwiseDataEncodedInfo >> 6 & 1) == 1
        
        self.isStrapIntact = UInt8(bitwiseDataEncodedInfo >> 5 & 1) == 1
        self.isStrapLocked = UInt8(bitwiseDataEncodedInfo >> 4 & 1) == 1
    }
}
