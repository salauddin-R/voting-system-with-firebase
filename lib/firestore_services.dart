import 'package:cloud_firestore/cloud_firestore.dart';

class firestoreData{
  final FirebaseFirestore _db=FirebaseFirestore.instance;
  Future<void> addItem(String question,List data)async{
   try{
     await _db.collection("surveys").add({
       "qyestuib":question,
       "options":data,
       "votes":List.filled(data.length,0)
     });
   }catch(e){
     print("data call failed $e");
   }
  }
  Future<void> voted(String id,int index)async{
    try{
     var doc= await _db.collection("surveys").doc(id).get();
     if(doc.exists){
       List vote=doc["votes"];
       vote[index]+=1;
       await _db.collection("surveys").doc(id).update({
         "votes":vote
       });
     }
    }
    catch(e){
      print("There is no vote. The erroe is $e");
    }
  }
  Future<void> deleteItem(String id)async{
    await _db.collection("surveys").doc(id).delete();
  }
  Stream<QuerySnapshot> fetchData(){
    return _db.collection("surveys").snapshots();
  }
}