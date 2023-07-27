import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils.dart';
import '../../loading/loading_controller.dart';
import '../controller/auth_controller.dart';

class UpdateUserProfileView extends ConsumerStatefulWidget {
  const UpdateUserProfileView({super.key, required this.userId});

  final String userId;

  @override
  ConsumerState<UpdateUserProfileView> createState() =>
      _UpdateUserProfileViewState();
}

class _UpdateUserProfileViewState extends ConsumerState<UpdateUserProfileView> {
  File? _image;
  final bool _isGettingLocation = false;

  String _nameController = '';

  void _submitData() async {
    if (_nameController.isEmpty) {
      showSnackbar(context, 'Please enter your name');
      return;
    }

    if (_image == null) {
      showSnackbar(context, 'Please add an image');
      return;
    }

    ref.read(authControllerProvider.notifier).createOrUpdateUser(
          ref,
          context,
          widget.userId,
          _nameController,
          '+${widget.userId}',
          _image!.path,
        );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(loadingProvider);
    final currentUserModel = ref.watch(authControllerProvider);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.white,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 24, horizontal: 40),
                  child: Center(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(50),
                      enableFeedback: true,
                      onTap: () async {
                        final pickedImage = await pickImage();
                        if (pickedImage != null) {
                          setState(() {
                            _image = pickedImage;
                          });
                        }
                      },
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 55,
                            backgroundColor: Colors.black,
                            child: CircleAvatar(
                              radius: 52,
                              backgroundColor: Colors.white,
                              backgroundImage: _image == null
                                  ? currentUserModel.imageUrl.isEmpty
                                      ? const NetworkImage(
                                          'https://as1.ftcdn.net/v2/jpg/03/46/83/96/1000_F_346839683_6nAPzbhpSkIpb8pmAwufkC7c5eD7wYws.jpg')
                                      : NetworkImage(currentUserModel.imageUrl)
                                          as ImageProvider<Object>
                                  : FileImage(
                                      File(_image!.path),
                                    ),
                            ),
                          ),
                          const Positioned(
                            bottom: 2,
                            right: 0,
                            child: CircleAvatar(
                              backgroundColor: Colors.black,
                              radius: 17,
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 15,
                                child: Icon(
                                  Icons.add,
                                  size: 24,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: TextFormField(
                    initialValue: currentUserModel.name,
                    onChanged: (value) {
                      setState(() {
                        _nameController = value;
                      });
                    },
                    autocorrect: true,
                    enableSuggestions: true,
                    keyboardType: TextInputType.emailAddress,
                    onSaved: (value) {},
                    cursorColor: Colors.black,
                    style: const TextStyle(color: Colors.black),
                    decoration: const InputDecoration(
                      hintText: 'Name',
                      alignLabelWithHint: true,
                      hintStyle: TextStyle(color: Colors.black),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    minWidth: double.infinity,
                    height: 60,
                    color: Colors.black,
                    onPressed: _isGettingLocation
                        ? () {}
                        : isLoading
                            ? () {}
                            : _submitData,
                    child: _isGettingLocation
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : isLoading
                            ? const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'Submit',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
