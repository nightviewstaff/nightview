import 'package:flutter/material.dart';

class CompleteProfileScreen extends StatelessWidget {
  final String firstName;
  final String lastName;
  final String mail;
  final Function(
      String phone,
      int birthdateDay,
      int birthdateMonth,
      int birthdateYear,
      ) onProfileComplete;

  CompleteProfileScreen({super.key, 
    required this.firstName,
    required this.lastName,
    required this.mail,
    required this.onProfileComplete,
  });

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Complete Your Profile")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: "Phone Number",
                hintText: "+1234567890",
              ),
            ),
            TextField(
              controller: birthDateController,
              keyboardType: TextInputType.datetime,
              decoration: InputDecoration(
                labelText: "Birth Date",
                hintText: "DD/MM/YYYY",
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final phone = phoneController.text.trim();
                final birthDate = birthDateController.text.trim();
                final parts = birthDate.split('/');

                if (phone.isNotEmpty && parts.length == 3) {
                  final birthdateDay = int.tryParse(parts[0]) ?? 0;
                  final birthdateMonth = int.tryParse(parts[1]) ?? 0;
                  final birthdateYear = int.tryParse(parts[2]) ?? 0;

                  if (birthdateDay > 0 && birthdateMonth > 0 && birthdateYear > 0) {
                    onProfileComplete(
                      phone,
                      birthdateDay,
                      birthdateMonth,
                      birthdateYear,
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Invalid birth date format")),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Please fill in all fields")),
                  );
                }
              },
              child: Text("Save and Continue"),
            ),
          ],
        ),
      ),
    );
  }
}
