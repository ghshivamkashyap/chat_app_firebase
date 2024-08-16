import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:flutter/widgets.dart';

class UserImagePicker extends StatefulWidget {
  const UserImagePicker({super.key, required this.onPickImage});

  final void Function(File pickedImage) onPickImage;

  @override
  State<UserImagePicker> createState() {
    return _UserImagepickerState();
  }
}

class _UserImagepickerState extends State<UserImagePicker> {
  // ignore: non_constant_identifier_names
  File? _UserPickedImage;
  void _pickImage() async {
    final pickedImage = await ImagePicker().pickImage(
        source: ImageSource.camera, maxHeight: 150, imageQuality: 50);

    if (pickedImage == null) {
      return;
    }

    setState(() {
      _UserPickedImage = File(pickedImage.path);
    });

    widget.onPickImage(_UserPickedImage!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: Colors.grey,
          radius: 40,
          foregroundImage:
              _UserPickedImage != null ? FileImage(_UserPickedImage!) : null,
        ),
        TextButton.icon(
          onPressed: _pickImage,
          label: Text(
            'Select image',
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
          icon: const Icon(Icons.image_outlined),
        )
      ],
    );
  }
}
