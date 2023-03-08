# Barcode Scanner


This is a simple barcode scanner app developed in SwiftUI that allows users to scan barcodes using their device camera. The app integrates with UIKit to access the camera and scan the barcode. It uses the MVVM design pattern for its architecture.


## Requirements

- Xcode 12 or Higher
- iOS 14.0 or Higher



## Getting Started

To get started with the app, follow these steps:

- Clone the repository or download the zip file.
- Open the project in Xcode.
- Run the app on a simulator or a physical device. (In the simulator the camera do not work.)

## Features

- Scan barcodes using the device camera.
- Display the scanned barcode in a text field.
- Ean8 and Ean13 supported


## Architecture

The app follows the MVVM (Model-View-ViewModel) design pattern. The main components of the app's architecture are:

**View**: Displays the UI of the app and sends user actions to the ViewModel.
**ViewModel**: Contains the business logic of the app and communicates with the Model to update the View.
**Model**: Represents the data and the logic related to the data, such as the barcode value.

## Integration with UIKit

The app integrates with UIKit to access the camera and scan the barcode. This is done by creating a UIViewRepresentable that wraps a UIView subclass that uses AVFoundation to capture and process the video frames from the camera. The UIViewRepresentable conforms to the UIViewControllerRepresentable protocol to handle the view controller lifecycle events.

## Code Structure

The code is organized into the following folders:

Model: Contains the data model of the app.
Views: Contains the SwiftUI views of the app.
ViewModel: Contains the view models of the app.
