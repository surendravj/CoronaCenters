import 'package:covidcenters/models/info.dart';
import 'package:covidcenters/widgets/infoHolder.dart';
import 'package:flutter/material.dart';

class InfoPage extends StatefulWidget {
  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  var infos = Infos().getInfo;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical:30),
      child: Container(
        height: MediaQuery.of(context).size.height,
        child: ListView.builder(
          itemBuilder: (ctx, index) => InfoHolder(infos[index]),
          itemCount: infos.length,
        ),
      ),
    );
  }
}
