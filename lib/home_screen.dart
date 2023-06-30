import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'chracteristic_screen.dart';


class BlueInfo{
  BlueInfo({required this.id,required this.name,required this.number,required this.ble,required this.isConnecting});
  DeviceIdentifier id;
  String name;
  int number;
  BluetoothDevice ble;
  bool isConnecting;
}

FlutterBluePlus flutterBlue = FlutterBluePlus.instance;
List<String>li1 = <String>[];
List<DeviceIdentifier>li2 = <DeviceIdentifier>[];
List<int>li3 = <int>[];
List<BluetoothDevice>li4 = <BluetoothDevice>[];
List<bool>li5 = <bool>[];




class HomeScreen extends HookConsumerWidget{
  // const HomeScreen({Key? key, required this.devices}) : super(key: key);
  
  late final BluetoothDevice devices;
  @override
  Widget build(BuildContext context,WidgetRef ref){
   var isBool = useState<bool>(false);
   var isConnect = useState<bool>(false);
   var isConnecting = useState<List<bool>>([]);
   var bgColor = useState<Color>(Colors.white);
   final _controller = ScrollController();

   List<BlueInfo>ble;


void searchList(){
  print("Bluetooth List");
  
  try{
   print("sucess!!");
   flutterBlue.startScan(timeout:Duration(seconds: 4));
   flutterBlue.scanResults.listen((results){
    for(ScanResult r in results){
        //  print(r.device.name);
        //  print(r.device.id);
        //  print(r.rssi);
        //  li1.add(r.device.name);
        //  li2.add(r.device.id);
        //  li3.add(r.rssi);
         ble =  [new BlueInfo(id: r.device.id, name: r.device.name, number: r.rssi,isConnecting: false,ble:r.device)];
          
        // var temp = ble.toSet().toList();

        var result = ble.where((bl)=>bl.name.length > 0);
        
        result.forEach((r)=>{
          print(r.id),
          print("名前" + r.name),
          print(r.number),
          li1.add(r.name),
          li2.add(r.id),
          li3.add(r.number),
          li4.add(r.ble),
          li5.add(r.isConnecting),
          isConnecting.value.add(false),
        });

       
        

    }
       
    
   });
   
   
  //  flutterBlue.stopScan();
  }catch(err){
   print(err);
  }
}

void connectDevice(String dvname,BluetoothDevice bl,int i){
  

  showDialog(context: context, builder:(BuildContext context){
     return AlertDialog(
      title:Text("接続確認"),
      content: Text(dvname + "の接続しますか？",style:TextStyle(fontSize: 15,fontWeight: FontWeight.bold)),
      actions: [
        TextButton(onPressed:()async{
          print("connected!!!");
          try{
            await bl.connect();
          print("Connected Success!!!");
          List<BluetoothService> bleServices = await bl.discoverServices();
          bleServices.forEach((bs){
            print(bs.characteristics.first);
          });

          
            // print(bleServices);
          // isConnecting.value[i] = true;
          }catch(err){
            print(err);
          }finally{
            print("サービスの開始");
             

          }
          Navigator.pop(context);
          
          Navigator.push(
            context,
            MaterialPageRoute(builder:(context)=>Characteristic(bl))
          );
        }, child: Text("OK")),
        TextButton(onPressed:(){
          Navigator.pop(context);
        }, child: Text("CANCEL"))
      ],
     );
  });

}

void disconnectDevice(String dvname,BluetoothDevice bl,int i)async{
     showDialog(context: context, builder:(BuildContext context){
     return AlertDialog(
      title:Text("接続確認"),
      content: Text(dvname + "の接続を切りますか？",style:TextStyle(fontSize: 15,fontWeight: FontWeight.bold)),
      actions: [
        TextButton(onPressed:(){
          // print("connected!!!");
          // if(isConnect.value == true){
          
          //   devices.disconnect();
          //   print("You finished connecting");

         
          // }else{
            
          // Navigator.pop(context);

          // }
          try{
            bl.disconnect();
            print('${dvname}の接続を切りました');
            // isConnecting.value[i] = false;
          }catch(err){
            print(err);
          }
          Navigator.pop(context);
        }, child: Text("OK")),
        TextButton(onPressed:(){
          Navigator.pop(context);
        }, child: Text("CANCEL"))
      ],
     );
  });
}


    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title:Text("Home",style:TextStyle(fontSize: 25)),
        centerTitle: true,
        actions: [
          Switch(value: isBool.value, onChanged:(bool value){
            
              isBool.value = value;
               if(isBool.value){
                searchList();
               }
            
          })
        ],
      ),
      body:Center(
        child:isBool.value == false ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("No devices",style:TextStyle(fontSize: 18)),
          ],
        ) :
         SingleChildScrollView(
         controller: _controller,
         child: Column(
          children: [
          SizedBox(height:50),
          Text("Bluetoothリスト",style:TextStyle(fontSize: 25)),
          Text(isBool.value.toString()),
          for(int i=0;i<li2.length;i++)
         
           Card(
            
            shadowColor: Colors.grey,
            elevation:10,
            child:InkWell(
             onTap: (){
               print("タップ");
               connectDevice(li1[i],li4[i],i);
            
               
             },
             onLongPress: (){
              print("長押し");
              disconnectDevice(li1[i],li4[i],i);
              bgColor.value = Colors.white;
             },
             child:Container(
             height: 50,
             child:Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: [
                 Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  SizedBox(height: 5),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(li1[i],style:TextStyle(fontWeight: FontWeight.bold,color: Colors.green,fontSize: 18)),
                  ),
                  SizedBox(height: 5),
                  Text(li2[i].toString(),style:TextStyle(fontSize: 15))
                 ],),
                 Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: Text(li3[i].toString(),style:TextStyle(fontSize: 15)),
                  )
                 

              ],),
            ),
           ),
           ),
          
        ],)
         ),
        )
    );
  }
}

// void searchList(){
//   print("Bluetooth List");
  
//   try{
//    print("sucess!!");
//    flutterBlue.startScan(timeout:Duration(seconds: 4));
//    flutterBlue.scanResults.listen((results){
//     for(ScanResult r in results){
//          print(r.device.name);
//          print(r.device.id);
//          print(r.rssi);
//          li1.add(r.device.name);
//          li2.add(r.device.id);
//          li3.add(r.rssi);


//     }
//    });
//   }catch(err){
//    print(err);
//   }
// }