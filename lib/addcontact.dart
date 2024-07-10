import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

//ADD PHOTO
//FIRST NAME
//textbox
//PHONE NUMBER
//textbox
//ADD CONTACT BUTTON

//CAMERA
class AddContact extends StatefulWidget {
  const AddContact({super.key});
  @override
  State<AddContact> createState() => _AddContactState();
}

class _AddContactState extends State<AddContact> {
  final _addKey = GlobalKey<FormState>();
  final _firstnameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _numberController = TextEditingController();
  final _emailController = TextEditingController();

  //CAMERA
  // camera permission is denied by default
  Permission permission = Permission.camera;
  PermissionStatus permissionStatus = PermissionStatus.denied;
  File? imageFile;

  @override
  void initState() {
    super.initState();

    _listenForPermissionStatus();
  }

  void _listenForPermissionStatus() async {
    final status = await permission.status;
    setState(() => permissionStatus = status);
  }

  Future<void> requestPermission() async {
    final status = await permission.request();

    setState(() {
      print(status);
      permissionStatus = status;
      print(permissionStatus);
    });
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Add Contact')),
        body: Form(
            key: _addKey,
            child: ListView(
                padding: const EdgeInsets.all(20.0),
                children: <Widget>[
                  IconButton(
                      onPressed: () async {
                        if (permissionStatus == PermissionStatus.granted) {
                          final image = await ImagePicker()
                              .pickImage(source: ImageSource.camera);

                          setState(() {
                            imageFile = image == null ? null : File(image.path);
                          });
                        } else {
                          requestPermission();
                        }
                      },
                      icon: Icon(Icons.camera_alt)),
                  TextFormField(
                    controller: _firstnameController,
                    decoration: _inputDecoration('First Name'),
                    validator: (value) =>
                        value!.isEmpty ? 'This is a required field' : null,
                  ),
                  TextFormField(
                    controller: _lastnameController,
                    decoration: _inputDecoration('Last Name'),
                  ),
                  TextFormField(
                    controller: _numberController,
                    decoration: _inputDecoration('Phone Number'),
                    validator: (value) =>
                        value!.isEmpty ? 'This is a required field' : null,
                  ),
                  TextFormField(
                    controller: _emailController,
                    decoration: _inputDecoration('Email'),
                  ),
                  ElevatedButton(onPressed: null, child: Text("Add Contact"))
                ])));
  }
}
