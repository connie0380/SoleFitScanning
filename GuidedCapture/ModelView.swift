/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
A wrapper for AR QuickLook viewer that shows the reconstructed USDZ model
 file directly.
*/

import ARKit
import QuickLook
import SwiftUI
import UIKit
import os
import Model3DView

struct ModelView: View {
    @State var camera = PerspectiveCamera()
    @State var email: String = ""
    let modelFile: URL
    let endCaptureCallback: () -> Void

    var body: some View {
        VStack {
            ARQuickLookController(modelFile: modelFile, endCaptureCallback: endCaptureCallback)
//            Model3DView(file: modelFile)
//                .transform(scale: 0.3)
////                .cameraControls(OrbitControls(
////                    camera: $camera,
////                    sensitivity: 0.5
////                ))
//                .frame(maxWidth: .infinity, maxHeight: 300)
//            Text("Your scan is now complete.")
//               .font(.system(size: 22, weight: .bold))
//           Text("We’d love to send you a detailed analysis of your foot scan. Please enter your email address below to receive your report.")
//               .padding(.vertical)
//               .foregroundColor(.gray)
//           Text("Email")
//               .frame(maxWidth: .infinity, alignment: .leading)
//           TextField("example@email .com", text: $email)
//               .padding()
//               .foregroundColor(.white)
//               .background(.black.opacity(0.8))
//               .cornerRadius(10)
//           Spacer()
//           Button("Submit") {}
//                .padding(10)
//           Text("Finish")
//               .padding(10)
//               .foregroundColor(Color.blue)
//               .onTapGesture {
//                   
//               }
        }
        .padding()
    }
}

private struct ARQuickLookController: UIViewControllerRepresentable {
    static let logger = Logger(subsystem: GuidedCaptureSampleApp.subsystem,
                                category: "ARQuickLookController")

    let modelFile: URL
    let endCaptureCallback: () -> Void

    func makeUIViewController(context: Context) -> QLPreviewControllerWrapper {
        let controller = QLPreviewControllerWrapper()
        controller.qlvc.dataSource = context.coordinator
        controller.qlvc.delegate = context.coordinator
        return controller
    }

    func makeCoordinator() -> ARQuickLookController.Coordinator {
        return Coordinator(parent: self)
    }

    func updateUIViewController(_ uiViewController: QLPreviewControllerWrapper, context: Context) {}

    class Coordinator: NSObject, QLPreviewControllerDataSource, QLPreviewControllerDelegate {
        let parent: ARQuickLookController

        init(parent: ARQuickLookController) {
            self.parent = parent
        }

        func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
            return 1
        }

        func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
            return parent.modelFile as QLPreviewItem
        }

        func previewControllerWillDismiss(_ controller: QLPreviewController) {
            ARQuickLookController.logger.log("Exiting ARQL ...")
            parent.endCaptureCallback()
        }
    }
}

private class QLPreviewControllerWrapper: UIViewController {
    let qlvc = QLPreviewController()
    var qlPresented = false

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !qlPresented {
            present(qlvc, animated: false, completion: nil)
            qlPresented = true
        }
    }
}
