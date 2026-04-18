import 'package:flutter/material.dart';
import 'package:grocery_app/widgets/auth_button.dart';

import '../../../core/helper/constants/colors_resources.dart';
import '../../../core/helper/constants/sizes.dart';


class LocationScreen extends StatelessWidget {
  const LocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Icon(Icons.arrow_back_ios_new),
                  SizedBox(height: 20),

                  /// Illustration
                  Image.asset("images/Omnigo.png"),
                  SizedBox(height: 20),

                  Center(
                    child: Text(
                      "Select Your Location",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.black,
                      ),
                    ),
                  ),

                  const Text(
                    "Switch on your location to stay in tune with what's happening in your area",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: AppColors.lightText),
                  ),

                  const SizedBox(height: 20),

                  DropdownButtonFormField(
                    decoration: const InputDecoration(labelText: "Your Zone"),
                    items: ["Rawalpindi", "Islamabad"]
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (v) {},
                  ),

                  const SizedBox(height: 20),

                  DropdownButtonFormField(
                    decoration: const InputDecoration(labelText: "Your Area"),
                    items: ["Saddar", "6th Road"]
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (v) {},
                  ),

                  SizedBox(height: 50),

                  AuthButton(text: "Submit", onTap: () {}),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/*import 'package:flutter/material.dart';
import 'package:grocery_app/widgets/auth_button.dart';

class LocationScreen extends StatelessWidget {
  const LocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            SizedBox(height: 60),

            /// Illustration
            Image.asset("assets/images/location.png", height: 180),

            SizedBox(height: 20),

            Text(
              "Select Your Location",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 10),

            Text(
              "Switch on your location to stay in tune with what's happening in your area",
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 30),

            DropdownButtonFormField(
              items: [
                "Zone 1",
                "Zone 2",
              ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (value) {},
              decoration: InputDecoration(labelText: "Your Zone"),
            ),

            SizedBox(height: 20),

            DropdownButtonFormField(
              items: [
                "Area 1",
                "Area 2",
              ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (value) {},
              decoration: InputDecoration(labelText: "Your Area"),
            ),

            Spacer(),

            AuthButton(text: "Submit", onTap: () {}),
          ],
        ),
      ),
    );
  }
}*/
