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
                SizedBox(height: 15,),
                ListTile(
                  leading: Icon(Icons.add_alarm_outlined),
                  trailing: Text('X', style: TextStyle(fontSize: 12, color: Colors.white) ,),
                  title: Container(
                    child: Text(' Screen Time', style: TextStyle(fontSize: 17, color: Colors.white),),
                  ),
                ),
                SizedBox(height:25,),
                ListTile(
                  leading: Icon(Icons.add_to_home_screen),
                  trailing: Text('X-Time', style: TextStyle(fontSize: 12, color: Colors.white) ,),
                  title: Container(
                    child: Text('Average Screen Time', style: TextStyle(fontSize: 17, color: Colors.white),),
                  ),
                ),
                SizedBox(height:25,),
                ListTile(
                  leading: Icon(Icons.check_circle_outline),
                  trailing: Text('X-Time', style: TextStyle(fontSize: 12, color: Colors.white) ,),
                  title: Container(
                    child: Text(' Completed Goals', style: TextStyle(fontSize: 17, color: Colors.white),),
                  ),
                ),
                SizedBox(height:25,),
                ListTile(
                  leading: Icon(Icons.remove_circle_outline),
                  trailing: Text('X-Time', style: TextStyle(fontSize: 12, color: Colors.white) ,),
                  title: Container(
                    child: Text(' Uncompleted Goals', style: TextStyle(fontSize: 17, color: Colors.white),),
                  ),
                ),
                SizedBox(height:25,),
                ListTile(
                  leading: Icon(Icons.plus_one_rounded),
                  trailing: Text('X-Time', style: TextStyle(fontSize: 12, color: Colors.white) ,),
                  title: Container(
                    child: Text('Current screen count', style: TextStyle(fontSize: 17, color: Colors.white),),
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
