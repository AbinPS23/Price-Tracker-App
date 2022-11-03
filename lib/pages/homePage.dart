import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:grocery_price_tracker_app/assets.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

var now = DateTime.now();
var today = DateFormat('yyyy-MM-dd').format(now);
late double screenWidth;
late double screenHeight;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //uvf5i3m3sobhs75aqikxtnkwtslcvgoadf37f1a2oiq7zyi3r3u1r5blks6n
  var url =
      "https://commodities-api.com/api/$today?access_key=31ccfjrjf25shi8kxojd2xphzgfwup1nbrso18cv5uq8evz53fi7iv2gt9fo&base=USD";

  List<String> items = ["COCOA", "CORN", "OAT", "WHEAT", "RICE", "COFFEE"];
  List<MaterialColor> _color = [
    Colors.blue,
    Colors.indigo,
    Colors.deepPurple,
    Colors.green
  ];

  var data;

  Future fetchData() async {
    var res = await http.get(Uri.parse(url));
    data = jsonDecode(res.body)['data'];
    print(data);
  }

  Future refresh() async {
    await Future.delayed(const Duration(seconds: 3));
    setState(() {
      fetchData();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Colors.grey,
        appBar: AppBar(
          title: const Text("Products Price Tracker"),
          centerTitle: true,
        ),
        body: FutureBuilder(
          future: fetchData(),
          builder: (context, snapshot) {
            return data != null
                ? data["success"] != false
                    ? RefreshIndicator(
                        onRefresh: refresh,
                        child: ListView.builder(
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            // return Card(
                            //   child: Text(
                            //       "${items[index]}: \$${(data['rates'][items[index]]).toStringAsFixed(3)}"),
                            // );
                            final MaterialColor color =
                                _color[index % _color.length];
                            return itemTiles(index, color);
                            // return ListTile(
                            //   title: Text("${items[index]}"),
                            //   subtitle: Text("\$${(data['rates'][items[index]]).toStringAsFixed(3)}",style: TextStyle(
                            //     color: Colors.red,
                            //   ),),
                            // );
                          },
                        ),
                      )
                    : Stack(
                        children: [
                          Positioned(
                            left: MediaQuery.of(context).size.width / 5,
                            top: MediaQuery.of(context).size.height / 3,
                            child: const Text(
                              "Server not connected!!",
                              style: TextStyle(
                                color: Color.fromARGB(255, 167, 26, 16),
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const Center(
                              child: CircularProgressIndicator.adaptive())
                        ],
                      )
                : const Center(child: CircularProgressIndicator());
          },
        ));
  }

  Widget itemTiles(int index, MaterialColor color) {
    // return ListTile(
    //   leading: CircleAvatar(child: Text(items[index][0]),backgroundColor: color,),
    //   title: Text(items[index],style: TextStyle(fontWeight: FontWeight.bold),),
    //   subtitle: Text("\$${(data['rates'][items[index]]).toStringAsFixed(3)}",style: TextStyle(color: Colors.red),),
    // );

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(7),
              child: Image.asset(
                imgItems[index],
                fit: BoxFit.cover,
                color: Colors.black.withOpacity(0.6),
                colorBlendMode: BlendMode.darken,
              ),
            ),
            Center(
              child: data != null
                  ? ListTile(
                      title: Center(
                        child: Text(
                          items[index],
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                              color: Colors.white),
                        ),
                      ),subtitle: Center(
                        child: Text(
                            "\$${(data['rates'][items[index]]).toStringAsFixed(3)}",
                            style:const  TextStyle(color: Colors.red),
                          ),
                      ),

                    )
                  // ? Column(
                  //     children: [
                  //       Text(
                  //         items[index],
                  //         style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 25,color: Colors.white),
                  //       ),
                  //       Text(
                  //         "\$${(data['rates'][items[index]]).toStringAsFixed(3)}",
                  //         style:const  TextStyle(color: Colors.red),
                  //       ),
                  //     ],
                  //   )
                  : const CircularProgressIndicator(),
            )
          ],
        ),
      ),
    );
  }
}
