import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.symmetric(vertical: 40, horizontal: 10),
        children: [
          Divider(),
          ListTile(
            leading: Icon(Icons.timelapse_outlined),
            title: Container(
              child: Text('text12',
                style: TextStyle(fontSize: 20),
              ),
            ),
            subtitle: Column(
              children: [
                Container(
                  child: Text('Hehehhee'),
                ),
                SizedBox(height: 24,),

                Container(
                  child: Text('Hehehhee'),
                ), Container(
                  child: Text('Hehehhee'),
                ), Container(
                  child: Text('Hehehhee'),
                ), Container(
                  child: Text('Hehehhee'),
                ), Container(
                  child: Text('Hehehhee'),
                ),
              ],
            ),
            trailing: Text('Text2'),
            tileColor: Colors.indigoAccent,
          ),
          Divider(),

        ],
      ),
    );
  }
}
