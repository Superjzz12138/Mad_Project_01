import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 4,
        child: const MyHomePage(),
      ),
    );
  }
}


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}



class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String _imageUrl = 'https://picsum.photos/600/400';

  late final TextEditingController _myController;

  @override
  void initState() {
    super.initState();
    _myController = TextEditingController();
  }

  @override
  void dispose() {
    _myController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        bottom: const TabBar(
          tabs: [
            Tab(text: 'Text + AlertDialog'),
            Tab(text: 'Image.Network + TextField'),
            Tab(text: 'ElevatedButton'),
            Tab(text: 'ListView + Items by Card'),
          ],
        ),
      ),
      body: TabBarView(
        children: [



           //First Tab: Text + AlertDialog
          Container(                                                           
            color: Colors.white,
            child: Center(
              child: Column(mainAxisAlignment: MainAxisAlignment.center, spacing: 2.0,
                children: [
                  const Text('Welcome to Tab1!'),
                const SizedBox(height: 30),
                ElevatedButton(onPressed: (){
                  showDialog(context: context, 
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Alert Text'),
                      content: Text('Here shows the content of AleartDialog.'),
                      actions: [
                        TextButton(onPressed: (){
                          Navigator.of(context).pop();
                        }, child: Text('Close'))
                      ],
                    );
                  });
                }, child: Text('Press Button to Show Dialog'))
                ],
              ),
            ),
          ),






          //Second Tab: Image.Network + TextField
          Container(                                                            
            color: Color.fromARGB(0xFF, 0xD0, 0x89, 0xA7),
            child: Center(
              child: Column(mainAxisAlignment: MainAxisAlignment.center, spacing: 2.0,
                children: [
                  SizedBox(height: 50),
                  TextField(
                    controller: _myController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter URL of picture here~',
                      hintText: 'e.g. https://picsum.photos/600/400'
                    ),
                  ),
                  const SizedBox(height: 30,),

                  ElevatedButton(onPressed: () {
                    String newUrl = _myController.text.trim();
                    if (newUrl.isNotEmpty){
                      setState(() {
                        _imageUrl = newUrl;
                      });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Invalid Url!')),
                    );}
                  }, child: Text('Load Image')),

                  const SizedBox(height: 20,),

                  Image.network(
                    _imageUrl,
                  ),
                ],
              ),
            )
          ),





          //Third Tab: ElevatedButton
          Container(                                                            
            color: Color.fromARGB(0xFF, 0x71, 0x43, 0x29),
            child: Center(
              child: Column(mainAxisAlignment: MainAxisAlignment.center, spacing: 2.0,
                children: [
                  Text('Button has been pressed $_counter times'),
                  const SizedBox(height: 30),
                  ElevatedButton(onPressed: () { setState(() {
                    _counter++;

                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Counter Increased!!!'), duration: Duration(milliseconds: 300),)
                  );

                  }, child: Text('Press Me!')),
                  const SizedBox(height: 30),
                  ElevatedButton(onPressed: () { setState(() {
                    _counter = 0;

                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Counter Reset'), duration: Duration(milliseconds: 300),)
                  );
                  }, child: Text('Reset Counter')),
                ],
              ),
              ),
            ),





           //Forth Tab: ListView + Items by Card
          Container(                                                           
            color: Color.fromARGB(0xFF, 0xB5, 0xA1, 0x92),
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(12),
                  ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.brown,
                    child: Text('${index + 1}'),
                  ),
                  tileColor: Colors.brown[300],
                  title: Text('Item ${index + 1}'),
                  subtitle: Text('Description of item ${index + 1}.'),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('You clicked the card!'),duration: Duration(milliseconds: 300),),
                    );
                  },
                ),
              );
            },
            ),
          )
          ],


      ),
      bottomNavigationBar: const BottomAppBar(

        
      ),
    );
  }
}