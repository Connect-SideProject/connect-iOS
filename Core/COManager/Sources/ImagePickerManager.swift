//
//  ImagePickerManager.swift
//  COManager
//
//  Created by sean on 2022/10/09.
//

import Foundation
import UIKit

import Then

import COExtensions

public final class ImagePickerManager: NSObject {
  
  public static let shared: ImagePickerManager = ImagePickerManager()
  
  private lazy var picker = UIImagePickerController().then {
    $0.delegate = self
  }
  
  private lazy var actionSheet = UIAlertController(
    title: nil,
    message: nil,
    preferredStyle: .actionSheet
  ).then {
    let cancelAction = UIAlertAction(title: "취소", style: .cancel)
    let cameraAction = UIAlertAction(title: "카메라", style: .default) { _ in
      self.openCamera()
    }
    let photoAction = UIAlertAction(title: "사진첩", style: .default) { _ in
      self.openPhotoLibrary()
    }
    
    $0.addAction(cancelAction)
    $0.addAction(cameraAction)
    $0.addAction(photoAction)
  }
  
  private var notAvailableCameraAlert = UIAlertController(
    title: "카메라 사용 불가",
    message: "카메라를 사용할 수 있는 기기가 아닙니다.",
    preferredStyle: .alert
  ).then {
    let confirmAction = UIAlertAction(title: "확인", style: .default)
    $0.addAction(confirmAction)
  }
  
  private var viewController = UIApplication.getTopViewController()
  
  private var imageHandler: (UIImage) -> () = { _ in }
  
  public func selectedImage(_ callback: @escaping (UIImage) -> ()) {
    imageHandler = callback
    
    actionSheet.popoverPresentationController?.sourceView = self.viewController?.view
    
    viewController?.present(actionSheet, animated: true, completion: nil)
  }
  
  private func openCamera() {
    actionSheet.dismiss(animated: true, completion: nil)
    
    if(UIImagePickerController.isSourceTypeAvailable(.camera)){
      picker.sourceType = .camera
      viewController?.present(picker, animated: true, completion: nil)
    } else {
      viewController?.present(notAvailableCameraAlert, animated: true)
    }
  }
  
  private func openPhotoLibrary() {
    actionSheet.dismiss(animated: true, completion: nil)
    
    picker.sourceType = .photoLibrary
    self.viewController?.present(picker, animated: true, completion: nil)
  }
}

extension ImagePickerManager: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    picker.dismiss(animated: true, completion: nil)
  }
  
  public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    
    picker.dismiss(animated: true, completion: nil)
    
    guard let image = info[.originalImage] as? UIImage else {
      fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
    }
    imageHandler(image)
  }
  
  @objc func imagePickerController(_ picker: UIImagePickerController, pickedImage: UIImage?) {
    picker.dismiss(animated: true, completion: nil)
    
    guard let image = pickedImage else { return }
    
    imageHandler(image)
  }
}
