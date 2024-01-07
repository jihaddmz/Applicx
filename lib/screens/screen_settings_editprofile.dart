import 'package:applicx/components/button.dart';
import 'package:applicx/components/my_textfield.dart';
import 'package:applicx/components/text.dart';
import 'package:applicx/components/textfield_border.dart';
import 'package:applicx/helpers/helper_sharedpreferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class ScreenSettingsEditProfile extends StatefulWidget {
  ScreenSettingsEditProfile({required this.username});

  final String username;

  @override
  _ScreenSettingsEditProfile createState() => _ScreenSettingsEditProfile();
}

class _ScreenSettingsEditProfile extends State<ScreenSettingsEditProfile> {
  final TextEditingController _controllerUsername = TextEditingController();
  final TextEditingController _controllerAddress = TextEditingController();
  final TextEditingController _controllerPhoneNumber = TextEditingController();
  bool _editingEnabled = false;

  @override
  void initState() {
    super.initState();
    _controllerUsername.text = widget.username;
    HelperSharedPreferences.getAddress().then((value) {
      _controllerAddress.text = value;
    });

    HelperSharedPreferences.getPhoneNumber().then((value) {
      _controllerPhoneNumber.text = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FractionallySizedBox(
        widthFactor: 0.6,
        child: Visibility(
          visible: MediaQuery.of(context).viewInsets.bottom == 0,
          child: Button(_editingEnabled ? "Save" : "Edit", () async {
            if (_editingEnabled) {
              await HelperSharedPreferences.setAddress(_controllerAddress.text);
              await HelperSharedPreferences.setUsername(
                  _controllerUsername.text);
              await HelperSharedPreferences.setPhoneNumber(
                  _controllerPhoneNumber.text);
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
                      child: TextGrey("Check and update your \nprofile "),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: TextFieldBorder(
                          controller: _controllerUsername,
                          enabled: _editingEnabled,
                          label: "Username"),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: TextFieldBorder(
                          controller: _controllerAddress,
                          enabled: _editingEnabled,
                          label: "Address"),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: TextFieldBorder(
                          controller: _controllerPhoneNumber,
                          enabled: _editingEnabled,
                          label: "Phone Number"),
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
