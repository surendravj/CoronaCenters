import 'package:covidcenters/logic/centers.dart';
import 'package:covidcenters/widgets/centerDetails.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TextView extends StatefulWidget {
  @override
  _TextViewState createState() => _TextViewState();
}

class _TextViewState extends State<TextView> {
  @override
  Widget build(BuildContext context) {
    var data = Provider.of<Centers>(context);
    var centers = [
      ...{...data.centers}
    ];

    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
        height: MediaQuery.of(context).size.height,
        child: ListView.builder(
          itemBuilder: (context, index) =>
              centers[index].center == "This is you"
                  ? null
                  : CenterDetails(
                      centers[index],
                    ),
          itemCount: centers.length,
        ),
      ),
    );
  }
}
