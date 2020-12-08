import 'package:covidcenters/models/info.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoHolder extends StatelessWidget {
  final Info info;
  InfoHolder(this.info);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () => _launchUrl(info.link),
        splashColor: Colors.white,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.1,
          child: Card(
            color: Colors.red[400],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(
                  10.0,
                ),
              ),
            ),
            elevation: 2,
            child: Center(
              child: Text(
                info.title,
                style: TextStyle(
                  color: Colors.black,
                  letterSpacing: 0.6,
                  fontWeight: FontWeight.w800,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

_launchUrl(String url) async {
  String link = url;
  if (await canLaunch(link)) {
    await launch(link);
  } else {
    throw 'Could not navigate';
  }
}
