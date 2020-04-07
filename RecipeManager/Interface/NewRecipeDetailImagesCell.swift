//
//  NewRecipeDetailImagesCell.swift
//  RecipeManager
//
//  Created by Anton Stamme on 22.03.20.
//  Copyright © 2020 Anton Stamme. All rights reserved.
//

import Foundation
import UIKit

class NewRecipeDetailImagesCell: BaseTableViewCell {
    var _target: NewRecipeDetailCell!
    
    var images: [UIImage] { return _target._target.recipeImages }
    
    lazy var imagePicker: UIImagePickerController = {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        pickerController.mediaTypes = ["public.image"]
        pickerController.sourceType = .photoLibrary
        return pickerController
    }()
    
    lazy var newImageActionSheet: UIAlertController = {
        let controller = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: NSLocalizedString("Take Photo", comment: ""), style: .default) { (action) in
            self.imagePicker.sourceType = .camera
            self._target._target.present(self.imagePicker, animated: true) { }
        }
        let libraryAction = UIAlertAction(title: NSLocalizedString("Choose from Library", comment: ""), style: .default) { (action) in
            self.imagePicker.sourceType = .photoLibrary
            self._target._target.present(self.imagePicker, animated: true) { }
        }
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil)
        controller.addAction(libraryAction)
        controller.addAction(cameraAction)
        controller.addAction(cancelAction)
        return controller
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.contentInset = UIEdgeInsets(top: 0, left: NewRecipeDetailCell.contentInset, bottom: 0, right: NewRecipeDetailCell.contentInset * 4)
        cv.backgroundColor = .clear
        cv.delegate = self
        cv.dataSource = self
        cv.register(NewRecipeImageCell.self, forCellWithReuseIdentifier: "NewRecipeImageCell")
        cv.showsHorizontalScrollIndicator = false
        return cv
    }()
    
    func setUpViews() {
        contentView.addSubview(collectionView)
        contentView.addConstraints([
            NSLayoutConstraint(item: collectionView, attribute: .left, relatedBy: .equal, toItem: contentView, attribute: .left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: collectionView, attribute: .right, relatedBy: .equal, toItem: contentView, attribute: .right, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: collectionView, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: collectionView, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1, constant: 0)
        ])
    }
    
    func fillData() {
        
    }
}

extension NewRecipeDetailImagesCell: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard indexPath.item != images.count else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewRecipeImageCell", for: indexPath) as! NewRecipeImageCell
            cell.setUpViews()
            cell.fillData(image: nil)
            return cell
        }
        
        let image = images[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewRecipeImageCell", for: indexPath) as! NewRecipeImageCell
        cell.setUpViews()
        cell.fillData(image: image)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.height - 16, height: collectionView.bounds.height - 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.item != images.count else {
            _target._target.present(newImageActionSheet, animated: true, completion: nil)
            return
        }
        
        let editImageActionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let changeAction = UIAlertAction(title: NSLocalizedString("Change Photo", comment: ""), style: .default) { (action) in
            self.imagePicker.sourceType = .photoLibrary
            self._target._target.present(self.imagePicker, animated: true) { }
        }
        let removeAction = UIAlertAction(title: NSLocalizedString("Remove Photo", comment: ""), style: .destructive) { (action) in
            self._target._target.recipeImages.remove(at: indexPath.item)
            self.collectionView.deleteItems(at: [indexPath])
        }
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil)
        editImageActionSheet.addAction(changeAction)
        editImageActionSheet.addAction(removeAction)
        editImageActionSheet.addAction(cancelAction)
        
        _target._target.present(editImageActionSheet, animated: true, completion: nil)
    }
}

extension NewRecipeDetailImagesCell: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[.editedImage] as? UIImage else {
            print("failed to pick image")
            return
        }
        let indexPath = IndexPath(item: images.count, section: 0)
        _target._target.recipeImages.append(image)
        collectionView.insertItems(at: [indexPath])
    }
}

class NewRecipeImageCell: BaseCollectionViewCell {
    
    var image: UIImage? {
        didSet {
            imageView.image = image ?? UIImage(systemName: "camera.fill", withConfiguration: symbolConfig)
            imageView.contentMode = image != nil ? .scaleAspectFill : .center
            addImageLabel.isHidden = image != nil
        }
    }
    
    let symbolConfig = UIImage.SymbolConfiguration(scale: .large)
    lazy var imageView: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "camera.fill", withConfiguration: symbolConfig))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .center
        iv.tintColor = .tertiaryLabel
        return iv
    }()
    
    lazy var addImageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 10, weight: .semibold)
        label.textAlignment = .center
        label.text = NSLocalizedString("Add Photo", comment: "")
        label.numberOfLines = 2
        label.textColor = .tertiaryLabel
        return label
    }()
    
    override func setUpViews() {
        backgroundColor = .tertiarySystemGroupedBackground
        layer.shadowOffset = CGSize(width: 1, height: 1)
        layer.shadowRadius = 6
        layer.shadowOpacity = 0.2
        contentView.layer.masksToBounds = true
        
        contentView.addSubview(imageView)
        imageView.addSubview(addImageLabel)
        imageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        imageView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        
        addImageLabel.centerXAnchor.constraint(equalTo: imageView.centerXAnchor).isActive = true
        addImageLabel.centerYAnchor.constraint(equalTo: imageView.centerYAnchor, constant: 20).isActive = true

    }
    
    func fillData(image: UIImage?) {
        self.image = image
    }
}
