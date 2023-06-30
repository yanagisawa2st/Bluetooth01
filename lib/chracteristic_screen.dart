import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';


class Characteristic extends HookConsumerWidget{
  Characteristic(this.charact);    
  BluetoothDevice charact;
 
  
  @override
  Widget build(BuildContext context,WidgetRef ref){
    print("遷移テスト");
    print(charact);
    var UUID = useState<String>("");
    var svUUID = useState<String>("");
    var property = useState<String>("");

    //  List<BluetoothCharacteristic>chlist;

  //  void readChara(List<BluetoothCharacteristic>c)async{
  //    for(BluetoothCharacteristic blc in c){
  //      List<int>value = await blc.read();
  //      print(value);
  //    }
  //  }

   void getValues()async{
    var chlist;
     List<BluetoothService>ble = await charact.discoverServices();
      ble.forEach((b){
           chlist = b.characteristics;
          // readChara(chlist);
      });
      for(BluetoothCharacteristic blc in chlist){
        
        print('テストUUID:${blc.uuid}');
        print('テストサービスUUID：${blc.serviceUuid}');
        print('値のテスト2${blc.properties.broadcast}');
        UUID.value = blc.uuid.toString();
        svUUID.value = blc.serviceUuid.toString();
        property.value = blc.properties.broadcast.toString();
        List<int>value = await blc.read();
        print(value);
        // await blc.write([0x12,0x34]);
      }
   }
  
   

    useEffect((){
       getValues();
    },[]);
    return Scaffold(
       appBar: AppBar(
        leading: IconButton(onPressed:(){
          Navigator.pop(context);
          charact.disconnect();
          }, icon: Icon(Icons.chevron_left)),
        title: Text('デバイス名：${charact.name}'),
        centerTitle: true,
       ),
       body:Center(
         child:Column(
          children: [
             SizedBox(height: 15),
             Text("取得データリスト",style:TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
             SizedBox(height: 8,),
            //  Row(children: [
              Card(
                shadowColor: Colors.black,
                elevation: 18,
                // shape:RoundedRectangleBorder(
                //   borderRadius: BorderRadius.circular(20),
                // ),
              child:Container(
                decoration: BoxDecoration(
                  border:Border.all(color:Colors.grey,width: 2)
                ),
                child:Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                   Text("Characteristic-uuid:",style:TextStyle(fontSize: 15,fontWeight: FontWeight.bold)),
                   Text(UUID.value,style:TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color:Colors.green)),
                   SizedBox(height: 10,),
                   Text("Service-uuid:",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                   Text(svUUID.value,style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color:Colors.green),),
                   SizedBox(height: 10,),
                   Text("ブロードキャスト",style:TextStyle(fontSize: 15,fontWeight: FontWeight.bold)),
                   Text(property.value,style:TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color:Colors.green)),   
                ],)
              ),
              ),
            //  ],)
          ],
         ),
       )
    );
  }
}