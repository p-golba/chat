import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  final void Function(File pickedImage) imagePickFn;
  const UserImagePicker(this.imagePickFn, {super.key});

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _pickedImage;
  void pickImage() async {
    final picker = ImagePicker();
    final pickedPhoto = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxHeight: 150,
      maxWidth: 150,
    );
    setState(() {
      _pickedImage = File(pickedPhoto!.path);
    });
    widget.imagePickFn(_pickedImage as File);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          backgroundImage:
              _pickedImage != null ? FileImage(_pickedImage as File) : null,
        ),
        TextButton.icon(
          icon: const Icon(Icons.image),
          label: const Text('Add image'),
          onPressed: pickImage,
        ),
      ],
    );
  }
}
