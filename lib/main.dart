import 'package:flutter/material.dart';

void main()=>runApp(MaterialApp(home:HomePage(),));

class HomePage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sqflite example'),),

      body: Center(
        child: Column(
        children: <Widget> [
          //each button preforms a action
          //inserting database
          FlatButton(onPressed: (){

          }, child: Text('insert'),color: Colors.pink,),
          //sql query
          FlatButton(onPressed: (){

          }, child: Text('query'), color: Colors.grey,),
          //updating database files
          FlatButton(onPressed: (){

          }, child: Text('update'), color: Colors.green,),
         //deleting data
          FlatButton(onPressed: (){

          }, child: Text('delete'), color: Colors.red,),

        ],
        ),
      )
    );
  }
}