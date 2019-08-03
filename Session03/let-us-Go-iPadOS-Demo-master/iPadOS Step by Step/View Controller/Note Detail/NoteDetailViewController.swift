//
//  NoteDetailViewController.swift
//  iPadOS Step by Step
//
//  Created by BumMo Koo on 03/08/2019.
//  Copyright © 2019 BumMo Koo. All rights reserved.
//

import UIKit
// 화면 스캔
import VisionKit
import PencilKit
import SnapKit
import MobileCoreServices

class NoteDetailViewController: UIViewController {
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var imageView: UIImageView!
    private lazy var canvasView = PKCanvasView()
    
    var note: Note?
    
    private var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }
    
    // MARK: - View
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        loadCanvas()
    }
    
    private func setup() {
        view.backgroundColor = .secondarySystemBackground
        
        // Canvas
        canvasView.backgroundColor = .clear
        canvasView.isOpaque = false
        canvasView.delegate = self
        
        // 초기 도구 셋팅
        canvasView.tool = PKInkingTool(.pencil)
        
        containerView.addSubview(canvasView)
        canvasView.snp.makeConstraints{ (make) in
            make.edges.equalToSuperview()
        }
        
        // 툴바 추가
        let window = UIApplication.shared.windows.first!
        let picker = PKToolPicker.shared(for: window)
        picker?.addObserver(canvasView)
        picker?.setVisible(true, forFirstResponder: canvasView)
        canvasView.becomeFirstResponder()
        
        // Drop
        let drop = UIDropInteraction(delegate: self)
        view.addInteraction(drop)
    }
    
    // MARK: - Action
    @IBAction
    private func tapped(clearCanvas button: UIBarButtonItem) {
        clearCanvas()
    }
    
    @IBAction
    private func tapped(document button: UIBarButtonItem) {
        presentDocumentPicker()
    }
    
    @IBAction
    private func tapped(scanner button: UIBarButtonItem) {
        presentDocumentScanner()
    }
    
    @IBAction
    private func tapped(photoLibrary button: UIBarButtonItem) {
        presentImagePicker()
    }
    
    @IBAction
    private func tapped(share button: UIBarButtonItem) {
        presentSharesheet(button)
    }
    
    // MARK: -
    private func presentDocumentPicker() {
        let picker = UIDocumentPickerViewController(documentTypes: [kUTTypeImage as String], in: .import)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    private func presentDocumentScanner() {
        let scanner = VNDocumentCameraViewController()
        scanner.delegate = self
        present(scanner, animated: true)
    }
    
    private func presentImagePicker() {
        
    }
    
    private func presentSharesheet(_ sourceView: UIBarButtonItem? = nil) {
        
    }
    
    // MARK: - Canvas
    private func loadCanvas() {
        
    }
    
    private func saveCanvas() {
        
    }
    
    private func generateImage() -> UIImage? {
        return nil
    }
    
    private func clearCanvas() {
        
    }
}

// MARK: - Canvas
extension NoteDetailViewController: PKCanvasViewDelegate {
    
}

// MARK: - Drag & Drop
extension NoteDetailViewController: UIDropInteractionDelegate {
    // drop을 받을수있는지 확인해주는 메서드
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        return true
    }
    
    // 어떤 drop 프로퍼셔가 있는지 알려주는 메서드
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        return UIDropProposal(operation: .copy)
    }
    
    //
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        session.loadObjects(ofClass: UIImage.self) { (items) in
            let images = items as! [UIImage]
            self.image = images.first
        }
    }
}

// MARK: - Documenet picker
extension NoteDetailViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        
        defer {
            dismiss(animated: true)
        }
        
        guard let url = urls.first else { return }
        guard let data = try? Data(contentsOf: url) else { return }
        guard let image = UIImage(data: data) else { return }
        self.image = image
        
    }
}

// MARK: - Document scanner
extension NoteDetailViewController: VNDocumentCameraViewControllerDelegate {
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        scan.imageOfPage(at: 0)
    }
    
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
        
    }
    
    func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
        dismiss(animated: true)
    }
}

// MARK: - Image picker
extension NoteDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
}
