import Foundation
import CoreBluetooth

let delble = DLG()

print("Running")

let bleManager = CBCentralManager(delegate: delble, queue: nil)

var listOfWristbands: [UUID : WristbandData] = [:]

class DLG: NSObject, CBCentralManagerDelegate
{
    func centralManagerDidUpdateState(_ central: CBCentralManager)
    {
        if central.state == .poweredOn
        {
            bleManager.scanForPeripherals(withServices: nil, options: nil)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber)
    {
        if let manData = advertisementData[CBAdvertisementDataManufacturerDataKey] as? Data
        {
            if WristbandData.isWristband(manData: manData)
            {
                let wDataStruct = WristbandData(withManufacturerData: manData)
                if listOfWristbands[peripheral.identifier] == nil
                {
                    listOfWristbands[peripheral.identifier] = wDataStruct
                    print("[+] New wristband: \(peripheral.identifier)")
                    print(wDataStruct)

                }
            }
        }
    }
}

RunLoop.main.run()

