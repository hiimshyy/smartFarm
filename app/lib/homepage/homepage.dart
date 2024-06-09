import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartfarm_app/bottom_sections/bidao.dart';
import 'package:smartfarm_app/bottom_sections/cayot.dart';
import 'package:smartfarm_app/bottom_sections/hanhla.dart';
import 'package:smartfarm_app/charts/humidity_chart.dart';
import 'package:smartfarm_app/charts/light_intersity_chart.dart';
import 'package:smartfarm_app/database/mongodb.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  bool stateConnectionToDatabase = false;
  late DatabaseManager dbManager;

  @override
  void initState() {
    super.initState();
    dbManager = DatabaseManager(); // Khởi tạo DatabaseManager
    dbManager.connectToDatabase();
  }

  void updateSelectedIndex(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    dbManager = Provider.of<DatabaseManager>(context);
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Row1(),
          ),
          Expanded(
            flex: 1,
            child: Row2(
              onTap: (index) {
                updateSelectedIndex(index);
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: GetRow3Section(),
          ),
          Expanded(
            flex: 2,
            child: Row4(
              databaseManager: dbManager,
            ),
          ),
        ],
      ),
    );
  }

  Widget GetRow3Section() {
    switch (selectedIndex) {
      case 0:
        return BiDao(databaseManager: dbManager);
      case 1:
        return HanhLa(databaseManager: dbManager);
      case 2:
        return CayOt(databaseManager: dbManager);
      default:
        return Container();
    }
  }
}

class Row1 extends StatefulWidget {
  @override
  _Row1State createState() => _Row1State();
}

class _Row1State extends State<Row1> {
  late DatabaseManager dbManager;
  @override
  void initState() {
    super.initState();
    dbManager = DatabaseManager(); // Khởi tạo thể hiện của DatabaseManager
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('lib/assets/background2.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(),
        ),
        Positioned(
          top: 17,
          left: 10,
          child: ElevatedButton(
            onPressed: () async {
              await dbManager.connectToDatabase();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            child: const Text('Connect'),
          ),
        ),
      ],
    );
  }
}

class Row2 extends StatefulWidget {
  final ValueChanged<int>? onTap;

  const Row2({Key? key, this.onTap}) : super(key: key);

  @override
  _Row2State createState() => _Row2State();
}

class _Row2State extends State<Row2> {
  String tappedImage = "bi_dao";

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xff66ff33),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  tappedImage = 'bi_dao';
                  widget.onTap?.call(0);
                });
              },
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                          10.0), // Độ cong của khung văn bản
                      color: Colors.grey[200], // Màu nền của khung văn bản
                    ),
                    child: const Text(
                      "    Bí đao    ",
                      style: TextStyle(
                        color: Colors.black, // Màu của văn bản
                        fontSize: 16, // Kích thước của văn bản
                        fontWeight: FontWeight.bold, // Độ đậm của văn bản
                      ),
                    ),
                  ),
                  Image.asset(
                    'lib/assets/bi_dao.jpg',
                    fit: BoxFit.cover,
                    height: 110,
                    width: 90,
                    color: tappedImage == 'bi_dao'
                        ? const Color.fromARGB(92, 37, 36, 36).withOpacity(0.7)
                        : null,
                    colorBlendMode:
                        tappedImage == 'bi_dao' ? BlendMode.srcOver : null,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  tappedImage = 'hanh_la';
                  widget.onTap?.call(1);
                });
              },
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                          10.0), // Độ cong của khung văn bản
                      color: Colors.grey[200], // Màu nền của khung văn bản
                    ),
                    child: const Text(
                      "   Hành lá    ",
                      style: TextStyle(
                        color: Colors.black, // Màu của văn bản
                        fontSize: 16, // Kích thước của văn bản
                        fontWeight: FontWeight.bold, // Độ đậm của văn bản
                      ),
                    ),
                  ),
                  Image.asset(
                    'lib/assets/hanh_la.jpg',
                    height: 110,
                    width: 90,
                    fit: BoxFit.cover,
                    color: tappedImage == 'hanh_la'
                        ? const Color.fromARGB(92, 37, 36, 36).withOpacity(0.7)
                        : null,
                    colorBlendMode:
                        tappedImage == 'hanh_la' ? BlendMode.srcOver : null,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  tappedImage = 'cay_ot';
                  widget.onTap?.call(2);
                });
              },
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                          10.0), // Độ cong của khung văn bản
                      color: Colors.grey[200], // Màu nền của khung văn bản
                    ),
                    child: const Text(
                      "    Cây ớt    ",
                      style: TextStyle(
                        color: Colors.black, // Màu của văn bản
                        fontSize: 16, // Kích thước của văn bản
                        fontWeight: FontWeight.bold, // Độ đậm của văn bản
                      ),
                    ),
                  ),
                  Image.asset(
                    'lib/assets/cay_ot.jpg',
                    height: 110,
                    width: 90,
                    fit: BoxFit.cover,
                    color: tappedImage == 'cay_ot'
                        ? const Color.fromARGB(92, 37, 36, 36).withOpacity(0.7)
                        : null,
                    colorBlendMode:
                        tappedImage == 'cay_ot' ? BlendMode.srcOver : null,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'lib/assets/house1.png',
                  fit: BoxFit.cover,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Row4 extends StatefulWidget {
  final databaseManager;
  Row4({required this.databaseManager});
  @override
  _Row4State createState() => _Row4State(databaseManager);
}

class _Row4State extends State<Row4> {
  final databaseManager;
  bool pumpOn = false;
  bool lightOn = false;

  _Row4State(this.databaseManager);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xff66cc99),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    color: const Color(0xffffcc66),
                    child: const Center(
                      child: Text(
                        'Biểu đồ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 0), // Điều chỉnh khoảng cách theo nhu cầu
                  child: SizedBox(
                    height:
                        0, // Độ cao của SizedBox là 0, không chiếm không gian
                    child: Divider(
                      color: Colors.black, // Màu của đường kẻ
                      thickness: 1, // Độ dày của đường kẻ
                    ),
                  ),
                ),
                Expanded(
                  flex: 7,
                  child: Container(
                    color: const Color(0xffffcc66),
                    child: const Center(
                      child: Text(
                        'Độ ẩm',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 0), // Điều chỉnh khoảng cách theo nhu cầu
                  child: SizedBox(
                    height:
                        0, // Độ cao của SizedBox là 0, không chiếm không gian
                    child: Divider(
                      color: Colors.black, // Màu của đường kẻ
                      thickness: 1, // Độ dày của đường kẻ
                    ),
                  ),
                ),
                Expanded(
                  flex: 7,
                  child: Container(
                    color: const Color(0xffffcc66),
                    child: const Center(
                      child: Text(
                        'Ánh sáng',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 6,
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    setState(() {});
                    await databaseManager.connectToDatabase();
                  },
                  child: const Text('Start chart'),
                ),
                Expanded(
                  flex: 1,
                  child: HumidityChartWidget(databaseManager: databaseManager),
                ),
                Expanded(
                    flex: 1,
                    child: LightIntensityChartWidget(
                        databaseManager: databaseManager)),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              color: const Color.fromARGB(255, 241, 243, 242),
              child: Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Bơm nước'),
                          ElevatedButton(
                            onPressed: () async {
                              setState(() {
                                pumpOn = true;
                              });
                              await databaseManager.connectToDatabase();
                              await databaseManager.changeMotor2ON();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  pumpOn ? Colors.green : Colors.grey,
                            ),
                            child: const Text('ON'),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              setState(() {
                                pumpOn = false;
                              });
                              await databaseManager.connectToDatabase();
                              await databaseManager.changeMotor2OFF();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  !pumpOn ? Colors.green : Colors.grey,
                            ),
                            child: const Text('OFF'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Bóng đèn'),
                          ElevatedButton(
                            onPressed: () async {
                              await databaseManager.changeBulb2ON();
                              setState(() {
                                lightOn = true;
                              });
                              await databaseManager.connectToDatabase();
                              await databaseManager.changeBulb2ON();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  lightOn ? Colors.green : Colors.grey,
                            ),
                            child: const Text('ON'),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              setState(() {
                                lightOn = false;
                              });
                              await databaseManager.connectToDatabase();
                              await databaseManager.changeBulb2OFF();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  !lightOn ? Colors.green : Colors.grey,
                            ),
                            child: const Text('OFF'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
