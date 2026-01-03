import 'package:flutter/material.dart';
import 'package:zenthory/core/core.dart';

class AboutScreen extends StatelessWidget {
  final String? version;

  const AboutScreen({super.key, this.version});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.tr!.about_app(context.tr!.app_name))),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          bottom: AppDimensions.padding * 4,
          left: AppDimensions.padding,
          right: AppDimensions.padding,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                AppImages.logo,
                width: MediaQuery.of(context).size.width * 0.60,
              ),
            ),
            Text(
              context.tr!.about_app(context.tr!.app_name),
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text(
              context.tr!.about_app_description_1(context.tr!.app_name),
              style: TextStyle(fontSize: 15),
            ),
            SizedBox(height: 20),
            Text(
              context.tr!.about_app_description_2(context.tr!.app_name),
              style: TextStyle(fontSize: 15),
            ),
            SizedBox(height: 20),
            Text(
              context.tr!.about_app_description_3,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 40),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      context.tr!.powered_by,
                      style: TextStyle(fontSize: 15),
                    ),
                    SizedBox(width: 4),
                    Text(
                      "Tenvoro",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: context.colors.primary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                if (version != null)
                  Text(
                    context.tr!.version(version!),
                    style: TextStyle(fontSize: 15),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
