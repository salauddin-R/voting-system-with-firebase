import 'package:flutter/material.dart';
import 'firestore_services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _questionController=TextEditingController();
  TextEditingController _optionController=TextEditingController();
  List<dynamic> data=[];
  final firestoreData firestore=firestoreData();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Firebase Firestore"),
      ),
      body: Column(
        children: [
          Padding(padding:EdgeInsets.only(top: 5,bottom: 5,right: 20,left: 20),
          child: Column(
            children: [
              TextField(controller: _questionController,
                decoration:InputDecoration(labelText: "Enter Your Question"),
              ),
              Row(
                children: [
                  Expanded(child:TextField(controller: _optionController,
                    decoration:InputDecoration(labelText: "Enter Your Question"),
                  ),),
                  IconButton(onPressed:(){
                    setState(() {
                      data.add(_optionController.text);
                      _optionController.clear();
                    });
                  }, icon:Icon(Icons.add))
                ],
              ),
              Wrap(
                children:data.map((doc)=>Chip(label: Text("$doc"),)).toList(),
              ),
              ElevatedButton(onPressed:(){
                if(_questionController.text.isNotEmpty && data.length>=2){
                  setState(() {
                    firestore.addItem( _questionController.text,data);
                    _questionController.clear();
                    data.clear();
                  });
                }
              }, child:Text("Save Item"))
            ],
          ),
          ),
          Expanded(child:StreamBuilder(stream:firestore.fetchData(), 
              builder:(context,snapshot){
            return !snapshot.hasData?Center(child: Text("There is nod data"),):ListView(
              children:snapshot.data!.docs.map((doc){
               return Card(
                 margin: EdgeInsets.only(top: 7),
                 child: ListTile(
                   title: Text(doc["qyestuib"]),
                   onTap: ()=>firestore.deleteItem(doc.id),
                   subtitle: Column(
                     children:List.generate(doc["options"].length,(index){
                       return ListTile(
                         title: Text("${doc["options"][index]}"),
                         trailing: Text("${doc["votes"][index]}"),
                         onTap:()=>firestore.voted(doc.id,index),
                       );
                     })
                   ),
                 ),
               ); 
              }).toList()
            );
              }
          ))
        ],
      ),
    );
  }
}
