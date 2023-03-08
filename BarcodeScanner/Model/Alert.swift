//
//  Alert.swift
//  BarcodeScanner
//
//  Created by Lucas on 2023-03-07.
//

import SwiftUI


struct AlertItem: Identifiable {
    let id = UUID()
    let title: String
    let message: String
    let dismissButton: Alert.Button
}



struct AlertContext {
    static let invalidDeviceInput = AlertItem(title: "Invalid Device Input",
                                              message: "Camera error, unable to capture.",
                                              dismissButton: .default(Text("Ok")))
    
    static let invalidScannedValue = AlertItem(title: "Invalid Scanned Value",
                                              message: "Value not valid.",
                                              dismissButton: .default(Text("Ok")))
}
