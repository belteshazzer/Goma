import 'package:flutter/material.dart';

class ProfileBody extends StatelessWidget {
  const ProfileBody({
    super.key,
    required GlobalKey<FormState> formKey,
    required TextEditingController emailController,
    required this.isEditMode,
    required TextEditingController firstNameController,
    required TextEditingController middleNameController,
    required TextEditingController lastNameController,
    required TextEditingController phoneNumberController,
    required TextEditingController cityController,
  }) : _formKey = formKey, _emailController = emailController, _firstNameController = firstNameController, _middleNameController = middleNameController, _lastNameController = lastNameController, _phoneNumberController = phoneNumberController, _cityController = cityController;

  final GlobalKey<FormState> _formKey;
  final TextEditingController _emailController;
  final bool isEditMode;
  final TextEditingController _firstNameController;
  final TextEditingController _middleNameController;
  final TextEditingController _lastNameController;
  final TextEditingController _phoneNumberController;
  final TextEditingController _cityController;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    'Email:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: TextFormField(
                      controller: _emailController,
                      enabled: isEditMode,
                      decoration: const InputDecoration(
                        hintText: 'abc@def.ghi',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  const Text(
                    'First Name:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: TextFormField(
                      controller: _firstNameController,
                      enabled: isEditMode,
                      decoration: const InputDecoration(
                        hintText: 'Enter your first name',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your first name';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  const Text(
                    'Middle Name:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: TextFormField(
                      controller: _middleNameController,
                      enabled: isEditMode,
                      decoration: const InputDecoration(
                        hintText: 'Enter your middle name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  const Text(
                    'Last Name:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: TextFormField(
                      controller: _lastNameController,
                      enabled: isEditMode,
                      decoration: const InputDecoration(
                        hintText: 'Enter your last name',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your last name';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  const Text(
                    'Phone Number:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: TextFormField(
                      controller: _phoneNumberController,
                      enabled: isEditMode,
                      decoration: const InputDecoration(
                        hintText: 'Enter your phone number',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your phone number';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  const Text(
                    'Address:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: TextFormField(
                      controller: _cityController,
                      enabled: isEditMode,
                      decoration: const InputDecoration(
                        hintText: 'Enter your city',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your city';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
