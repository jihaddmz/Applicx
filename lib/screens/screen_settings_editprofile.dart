import 'package:applicx/components/button.dart';
import 'package:applicx/components/my_textfield.dart';
import 'package:applicx/components/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class ScreenSettingsEditProfile extends StatefulWidget {
  @override
  _ScreenSettingsEditProfile createState() => _ScreenSettingsEditProfile();
}

class _ScreenSettingsEditProfile extends State<ScreenSettingsEditProfile> {
  final TextEditingController _controllerUsername = TextEditingController();
  final TextEditingController _controllerAddress = TextEditingController();
  bool _editingEnabled = false;

  @override
  void initState() {
    _controllerUsername.text = "User123";
    _controllerAddress.text = "Street123";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FractionallySizedBox(
        widthFactor: 0.6,
        child: Button(_editingEnabled ? "Save" : "Edit", () {
          if (_editingEnabled) {
            setState(() {
              _editingEnabled = false;
            });
          } else {
            setState(() {
              _editingEnabled = true;
            });
          }
        }, color: const Color(0xff243141)),
      ),
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Image.asset("assets/images/image_back.png"),
        ),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              Positioned(
                  right: 0,
                  child: Image.asset(
                      "assets/images/image_chatbot_editprofile.png")),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextBoldBlack("Profile"),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: TextGrey("Update and modify your \nprofile "),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: MyTextField(
                          controller: _controllerUsername,
                          hintText: "Username",
                          showLabel: true,
                          prefixIcon: null,
                          enabled: _editingEnabled,
                          onValueChanged: (value) {}),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: MyTextField(
                          controller: _controllerAddress,
                          hintText: "Address",
                          showLabel: true,
                          prefixIcon: null,
                          enabled: _editingEnabled,
                          onValueChanged: (value) {}),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: SizedBox(
                        height: 200,
                        child: FlutterMap(
                            options: const MapOptions(
                                initialZoom: 15,
                                initialCenter: LatLng(33.872304, 35.498800)),
                            children: [
                              TileLayer(
                                urlTemplate:
                                    'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                userAgentPackageName: 'com.appsfourlife.com',
                              ),
                            ]),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
