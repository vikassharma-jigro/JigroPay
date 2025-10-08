import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

mixin ImagePickerMixin<T extends StatefulWidget> on State<T> {
  final ImagePicker _picker = ImagePicker();


  Future<XFile?> pickImage({
    required ImageSource source,
    bool allowCrop = false, // placeholder if you want to integrate cropping
  }) async {
    final hasPermission = await _handlePermission(source);
    if (!hasPermission) return null;

    try {
      final picked = await _picker.pickImage(
        source: source,
        maxWidth: 2048,
        maxHeight: 2048,
        imageQuality: 85, // 0-100, reduce to lower size if needed
      );

      if (picked == null) return null;

      // If you want to add cropping, do it here using image_cropper package.
      // Example (pseudo):
      // if (allowCrop) picked = await _cropImage(picked.path);

      return picked;
    } catch (e) {
      debugPrint('pickImage error: $e');
      return null;
    }
  }

  /// Pick multiple images from gallery (platform dependent).
  /// Returns list of [XFile] or null.
  Future<List<XFile>?> pickMultiImage() async {
    final hasPermission = await _handlePermission(ImageSource.gallery);
    if (!hasPermission) return null;

    try {
      final pickedList = await _picker.pickMultiImage(
        maxWidth: 2048,
        maxHeight: 2048,
        imageQuality: 85,
      );

      if (pickedList == null || pickedList.isEmpty) return null;
      return pickedList;
    } catch (e) {
      debugPrint('pickMultiImage error: $e');
      return null;
    }
  }

  /// Internal: request/check permissions based on [source]
  Future<bool> _handlePermission(ImageSource source) async {
    try {
      if (source == ImageSource.camera) {
        final status = await Permission.camera.status;
        if (status.isGranted) return true;
        final res = await Permission.camera.request();
        return res.isGranted;
      } else {
        // gallery/photos permission differs by platform
        if (Platform.isIOS) {
          final status = await Permission.photos.status;
          if (status.isGranted) return true;
          final res = await Permission.photos.request();
          return res.isGranted;
        } else {
          // Android
          final status = await Permission.storage.status;
          if (status.isGranted) return true;
          final res = await Permission.storage.request();
          return res.isGranted;
        }
      }
    } catch (e) {
      debugPrint('_handlePermission error: $e');
      return false;
    }
  }

  /// Optional helper to convert XFile -> File
  File? xFileToFile(XFile? xfile) => xfile == null ? null : File(xfile.path);


}

