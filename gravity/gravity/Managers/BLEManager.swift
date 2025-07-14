//
//  BLEManager.swift
//  gravity
//
//  Created by Braeden Hall on 2025-07-10.
//

import Foundation
import CoreBluetooth

struct BLECharacteristics {
    var write: CBCharacteristic?
    var notify: CBCharacteristic?
}

struct MPUData {
    let accX: Float32
    let accY: Float32
    let accZ: Float32
    let gyroX: Float32
    let gyroY: Float32
    let gyroZ: Float32
    let temp: Float32
}

struct OrientationData {
    let pitch: Float32
    let roll: Float32
    let yaw: Float32
}

class BLEManager: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    static let shared = BLEManager()
    
    var centralManager: CBCentralManager!
    var characteristics: BLECharacteristics = BLECharacteristics()
    
    @Published var mpuData: MPUData?
    @Published var peripheral: CBPeripheral?
    @Published var scanning: Bool = false
    @Published var connected: Bool = false

    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil, options: [
            CBCentralManagerOptionRestoreIdentifierKey: Bundle.main.bundleIdentifier! + ".ble"
        ])
    }

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            startScan()
        }
    }
    
    private func startScan() {
        scanning = true
        print("scan")
        centralManager.scanForPeripherals(withServices: [CBUUID(string: AppConfig.bleServiceID)], options: nil)
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("Discovered: \(peripheral.name ?? "unknown")")
        self.peripheral = peripheral
        peripheral.delegate = self
        centralManager.stopScan()
        scanning = false
        connect()
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected to: \(peripheral.name ?? "unknown")")
        connected = true
        peripheral.discoverServices(nil)
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        // Handle disconnection
        print("Disconnected from \(peripheral.name ?? "Unknown"): \(error?.localizedDescription ?? "No error")")
        connected = false
        startScan()
    }
    
    func centralManager(_ central: CBCentralManager, willRestoreState dict: [String : Any]) {
        print("Restoring BLE state: \(dict)")
        // You can restore peripherals from here if needed
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let error = error {
            print("Service discovery failed: \(error)")
            return
        }

        guard let services = peripheral.services else { return }

        for service in services {
            if service.uuid == CBUUID(string: AppConfig.bleServiceID) {
                print("Discovered service: \(service.uuid)")
                peripheral.discoverCharacteristics(nil, for: service)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let error = error {
            print("Characteristic discovery failed: \(error)")
            return
        }

        guard let chars = service.characteristics else { return }

        for characteristic in chars {
            print("Discovered characteristic: \(characteristic.uuid)")
            if characteristic.uuid == CBUUID(string: AppConfig.bleWriteCharID) {
                characteristics.write = characteristic
            }
            if characteristic.uuid == CBUUID(string: AppConfig.bleNotifyCharID) {
                peripheral.setNotifyValue(true, for: characteristic)
                characteristics.notify = characteristic
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error {
            print("Notification error: \(error)")
            return
        }
        
        guard characteristic.uuid.isEqual(CBUUID(string: AppConfig.bleNotifyCharID)) else {
            print("wrong characteristic")
            return
        }
        guard let data = characteristic.value else { return }
//        mpuData = data.withUnsafeBytes { $0.load(as: MPUData.self) } // Assumes data matches struct size
        let oData = data.withUnsafeBytes { $0.load(as: OrientationData.self) } // Assumes data matches struct size
        RocketModel.shared.setOreintation(pitch: oData.pitch, roll: oData.roll, yaw: oData.yaw)
        
        print("received data: \(oData)")
    }
    
    func connect() {
        guard let peripheral = peripheral else {
            print("No peripheral to connect to")
            return
        }
        
        centralManager.connect(peripheral, options: nil)
    }
    
    func disconnect() {
        guard let peripheral = peripheral else {
            print("No peripheral to connect to")
            return
        }
        
        centralManager.cancelPeripheralConnection(peripheral)
    }
    
//    func sendBleMsg(byte: UInt8) {
//        guard let peripheral = peripheral,
//              let characteristic = characteristics.write else {
//            print("Cannot send, peripheral or characteristic not ready")
//            return
//        }
//
//        var data = Data()
//        if let uuidData = "\(AppConfig.deviceID) ".data(using: .utf8) {
//            data.append(uuidData)
//        }
//        data.append(byte)
//        
//        peripheral.writeValue(data, for: characteristic, type: .withResponse)
//    }
}
