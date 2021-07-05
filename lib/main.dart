import 'package:flutter/material.dart';
import 'package:phoneapp/database_helper.dart';

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

              FlatButton(onPressed:() async {
                //in the insert, map has to be passed through
                int i = await db.note_database.instance.insert({
                  DatabaseHelper.columnName : 'HArry'
                });

                print('the inserted id $i');

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