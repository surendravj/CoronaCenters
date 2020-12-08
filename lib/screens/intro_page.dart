import 'package:covidcenters/dist.dart';
import 'package:covidcenters/logic/centers.dart';
import 'package:covidcenters/logic/covid_stats.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class IntroPage extends StatefulWidget {
  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  String dropdownValue = 'Select Region';
  Map<dynamic, dynamic> data;
  bool loading = true;
  @override
  void initState() {
    CovidStats().fetchData().then((value) {
      setState(() {
        data = value;
        loading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.only(left: 10.0, right: 10.0),
                height: MediaQuery.of(context).size.height * 0.2,
                child: Image.asset(
                  "assets/image.png",
                ),
              ),
              Center(
                child: Text(
                  'Covid Centers',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Center(
                child: Text(
                  'Telangana',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              buildContainerdropdownButton(context),
              SizedBox(
                height: 10,
              ),
              Center(
                child: Text(
                  'Select your region to find accurate results',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w400,
                    fontSize: 13,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Container buildContainerdropdownButton(BuildContext context) {
    return Container(
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.5,
          alignment: Alignment.center,
          padding: EdgeInsets.only(left: 10.0, right: 10.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.white,
            border: Border.all(),
          ),
          child: DropdownButton<String>(
            hint: Text("Select District"),
            isExpanded: true,
            value: dropdownValue,
            icon: Icon(
              Icons.arrow_downward,
              color: Colors.black,
            ),
            iconSize: 24,
            elevation: 16,
            style: TextStyle(color: Colors.black),
            underline: Container(
              height: 0,
              color: Colors.white,
              width: double.infinity,
            ),
            onChanged: (String newValue) {
              if (newValue == 'Select Region') {
                setState(
                  () {
                    dropdownValue = newValue;
                  },
                );
              } else {
                _showMyDialog(context, newValue);
                setState(
                  () {
                    dropdownValue = newValue;
                  },
                );
              }
            },
            items: dist.map<DropdownMenuItem<String>>(
              (String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              },
            ).toList(),
          ),
        ),
      ),
    );
  }
}

Future<void> _showMyDialog(BuildContext context, String district) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: true, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Selected District'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Are you sure '),
              Text('Would you like to confirm the $district district'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Confirm'),
            onPressed: () {
              Provider.of<Centers>(context, listen: false)
                  .setDistrict(district);
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('No'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
