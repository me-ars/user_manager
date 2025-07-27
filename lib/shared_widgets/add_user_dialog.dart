import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/user_model.dart';
import 'custom_button.dart';
import 'custom_text_field.dart';

class AddUserDialog {
  static void showAddUserPopup({
    required BuildContext context,
    required Function(UserModel) onAdd,
  }) {
    Size size = MediaQuery.of(context).size;
    TextEditingController firstNameController = TextEditingController();
    TextEditingController lastNameController = TextEditingController();
    TextEditingController emailController = TextEditingController();

    File? selectedImageFile;

    void _pickImage(ImageSource source) async {
      final picker = ImagePicker();
      final picked = await picker.pickImage(source: source);
      if (picked != null) {
        selectedImageFile = File(picked.path);
      }
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New User'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (_) {
                            return SafeArea(
                              child: Wrap(
                                children: [
                                  ListTile(
                                    leading: const Icon(Icons.camera_alt),
                                    title: const Text("Camera"),
                                    onTap: () async {
                                      Navigator.of(context).pop();
                                      final picker = ImagePicker();
                                      final image = await picker.pickImage(
                                          source: ImageSource.camera);
                                      if (image != null) {
                                        setState(() => selectedImageFile =
                                            File(image.path));
                                      }
                                    },
                                  ),
                                  ListTile(
                                    leading: const Icon(Icons.photo_library),
                                    title: const Text("Gallery"),
                                    onTap: () async {
                                      Navigator.of(context).pop();
                                      final picker = ImagePicker();
                                      final image = await picker.pickImage(
                                          source: ImageSource.gallery);
                                      if (image != null) {
                                        setState(() => selectedImageFile =
                                            File(image.path));
                                      }
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      child: CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.grey[200],
                        backgroundImage: selectedImageFile != null
                            ? FileImage(selectedImageFile!)
                            : null,
                        child: selectedImageFile == null
                            ? const Icon(Icons.camera_alt, size: 30)
                            : null,
                      ),
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      height: size.height * 0.08,
                      width: size.width * 0.8,
                      controller: firstNameController,
                      labelText: "First Name",
                      maxLength: 100,
                      isPassword: false,
                    ),
                    CustomTextField(
                      height: size.height * 0.08,
                      width: size.width * 0.8,
                      controller: lastNameController,
                      labelText: "Last Name",
                      maxLength: 100,
                      isPassword: false,
                    ),
                    CustomTextField(
                      height: size.height * 0.08,
                      width: size.width * 0.8,
                      controller: emailController,
                      labelText: "Email",
                      maxLength: 100,
                      isPassword: false,
                    ),
                    const SizedBox(height: 16),
                    CustomButton(
                      height: size.height * 0.08,
                      width: size.width * 0.8,
                      buttonText: "Add",
                      onTap: () {
                        if (firstNameController.text.isEmpty ||
                            lastNameController.text.isEmpty ||
                            emailController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("All fields are required")),
                          );
                          return;
                        }

                        final newUser = UserModel(
                          id: DateTime.now().millisecondsSinceEpoch,
                          email: emailController.text.trim(),
                          firstName: firstNameController.text.trim(),
                          lastName: lastNameController.text.trim(),
                          avatar: selectedImageFile?.path ?? "",
                        );

                        Navigator.of(context).pop();
                        onAdd(newUser); // ✅ Pass newUser to BLoC
                      },

                    ),
                  ],
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
