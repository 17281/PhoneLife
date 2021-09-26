import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        children: [
          ListTile(
            tileColor: Colors.grey,
            title: Container(
              child: Text('User Stats',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
            subtitle: Column(
              children: [
                SizedBox(height: 30,),
                ListTile(
                  leading: Icon(Icons.timelapse_outlined),
                  trailing: Text('X-Time', style: TextStyle(fontSize: 15, color: Colors.white) ,),
                  title: Container(
                    child: Text('Time', style: TextStyle(fontSize: 20, color: Colors.white),),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.timelapse_outlined),
                  trailing: Text('X-Time', style: TextStyle(fontSize: 15, color: Colors.white) ,),
                  title: Container(
                    child: Text('Time', style: TextStyle(fontSize: 20, color: Colors.white),),
                  ),
                ),ListTile(
                  leading: Icon(Icons.timelapse_outlined),
                  trailing: Text('X-Time', style: TextStyle(fontSize: 15, color: Colors.white) ,),
                  title: Container(
                    child: Text('Time', style: TextStyle(fontSize: 20, color: Colors.white),),
                  ),
                ),ListTile(
                  leading: Icon(Icons.timelapse_outlined),
                  trailing: Text('X-Time', style: TextStyle(fontSize: 15, color: Colors.white) ,),
                  title: Container(
                    child: Text('Time', style: TextStyle(fontSize: 20, color: Colors.white),),
                  ),
                ),ListTile(
                  leading: Icon(Icons.timelapse_outlined),
                  trailing: Text('X-Time', style: TextStyle(fontSize: 15, color: Colors.white) ,),
                  title: Container(
                    child: Text('Time', style: TextStyle(fontSize: 20, color: Colors.white),),
                  ),
                ),
              ],
            ),
          ),
          Divider(),
        ],
      ),
    );
  }
}
