//
//  BarcodeScannerViewModel.swift
//  BarcodeScanner
//
//  Created by Lucas on 2023-03-07.
//

import SwiftUI


final class BarcodeScannerViewModel: ObservableObject {
    
    
    @Published var scannedCode = ""
    @Published var alertItem: AlertItem?
    
    var statusText: String {
        
        return scannedCode.isEmpty ? "Barcode Not Scanned" : scannedCode
        
        
    }
    
    
    var statusColor: Color {
        
      return scannedCode.isEmpty ? .red : .green
        
    }
    
    
    
}
