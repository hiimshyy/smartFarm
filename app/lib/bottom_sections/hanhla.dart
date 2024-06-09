import 'package:flutter/material.dart';

class HanhLa extends StatefulWidget {
  final databaseManager;
  HanhLa({required this.databaseManager});
  @override
  _HanhLaState createState() => _HanhLaState(databaseManager);
}

class _HanhLaState extends State<HanhLa> {
  final databaseManager;
  int soNgayHanhLa = 0;
  int cuongDoAnhSangHanhLa = 0;
  int doAmHanhLa = 0;
  _HanhLaState(this.databaseManager);
  double humidity = 0;
  double lightIntensity = 0;

  void tangSoNgay() {
    setState(() {
      soNgayHanhLa++;
      if (soNgayHanhLa >= 7 && soNgayHanhLa <= 14) {
        doAmHanhLa = 60;
        cuongDoAnhSangHanhLa = 8;
      } else if (soNgayHanhLa > 14 && soNgayHanhLa < 22) {
        doAmHanhLa = 65;
        cuongDoAnhSangHanhLa = 9;
      } else if (soNgayHanhLa >= 22 && soNgayHanhLa < 40) {
        doAmHanhLa = 70;
        cuongDoAnhSangHanhLa = 10;
      } else {
        doAmHanhLa = 80;
        cuongDoAnhSangHanhLa = 0;
      }
    });
  }

  void giamSoNgay() {
    if (soNgayHanhLa > 0) {
      setState(() {
        soNgayHanhLa--;
        if (soNgayHanhLa >= 7 && soNgayHanhLa <= 14) {
          doAmHanhLa = 60;
          cuongDoAnhSangHanhLa = 8;
        } else if (soNgayHanhLa > 14 && soNgayHanhLa < 22) {
          doAmHanhLa = 65;
          cuongDoAnhSangHanhLa = 9;
        } else if (soNgayHanhLa >= 22 && soNgayHanhLa < 40) {
          doAmHanhLa = 70;
          cuongDoAnhSangHanhLa = 10;
        } else {
          doAmHanhLa = 80;
          cuongDoAnhSangHanhLa = 0;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Table(
        border: TableBorder.all(),
        columnWidths: const {
          0: FlexColumnWidth(1), // Set the first column width
          1: FlexColumnWidth(1), // Set the second column width
          2: FlexColumnWidth(1), // Set the third column width
          3: FlexColumnWidth(1), // Set the fourth column width
        },
        children: [
          // Header row
          TableRow(
            decoration: const BoxDecoration(
              color: Color(0xffffcc66),
            ),
            children: [
              TableCell(
                child: ElevatedButton(
                  onPressed: () async {
                    await databaseManager.connectToDatabase();
                    var newHumidity = await databaseManager.findHumidityValue();
                    var newLightIntensity =
                        await databaseManager.findLightIntensityValue();
                    setState(() {
                      humidity = newHumidity;
                      lightIntensity = newLightIntensity;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color(0xffffcc66), // Màu nền của container
                  ),
                  child: const Text('UPDATE'),
                ),
              ),
              TableCell(
                child: Container(
                  height: 40, // Set the height of the row
                  child: const Center(
                    child: Text(
                      'Số ngày',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20, // Set the font size
                        fontWeight: FontWeight.bold, // Set the font weight
                      ),
                    ),
                  ),
                ),
              ),
              TableCell(
                child: Container(
                  height: 40, // Set the height of the row
                  child: const Center(
                    child: Text(
                      'Ánh sáng',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20, // Set the font size
                        fontWeight: FontWeight.bold, // Set the font weight
                      ),
                    ),
                  ),
                ),
              ),
              TableCell(
                child: Container(
                  height: 40, // Set the height of the row
                  child: const Center(
                    child: Text(
                      'Độ ẩm',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20, // Set the font size
                        fontWeight: FontWeight.bold, // Set the font weight
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Empty row 1
          TableRow(
            children: [
              TableCell(
                child: Container(
                  height: 40, // Set the height of the row
                  color: Colors.blue,
                  child: const Center(
                    child: Text(
                      'Kỳ vọng',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20, // Set the font size
                        fontWeight: FontWeight.bold, // Set the font weight
                      ),
                    ),
                  ),
                ),
              ),
              //---------------số ngày kỳ vọng từng loại cây-----------------
              TableCell(
                child: Container(
                  height: 40, // Set the height of the row
                  child: const Center(
                    child: Text(
                      '90',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16, // Set the font size
                        fontWeight: FontWeight.bold, // Set the font weight
                      ),
                    ),
                  ),
                ),
              ),
              //----Ánh sáng------
              TableCell(
                child: Container(
                  height: 40, // Set the height of the row
                  child: Center(
                    child: Text(
                      '$cuongDoAnhSangHanhLa', // Hiển thị mức độ cường độ ánh sáng
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16, // Set the font size
                        fontWeight: FontWeight.bold, // Set the font weight
                      ),
                    ),
                  ),
                ),
              ),
              //---------------------Độ ẩm------------------------
              TableCell(
                child: Container(
                  height: 40, // Set the height of the row
                  child: Center(
                    child: Text(
                      '$doAmHanhLa' + '%', // Hiển thị mức độ cường độ ánh sáng
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16, // Set the font size
                        fontWeight: FontWeight.bold, // Set the font weight
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Empty row 2
          TableRow(
            children: [
              TableCell(
                child: Container(
                  height: 40, // Set the height of the row
                  color: Colors.blue,
                  child: const Center(
                    child: Text(
                      'Thực tế',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20, // Set the font size
                        fontWeight: FontWeight.bold, // Set the font weight
                      ),
                    ),
                  ),
                ),
              ),
              TableCell(
                child: Container(
                  height: 40, // Set the height of the row
                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.center, // căn giữa các widget con
                    children: [
                      Text(
                        '$soNgayHanhLa',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16, // Set the font size
                          fontWeight: FontWeight.bold, // Set the font weight
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: tangSoNgay,
                        iconSize: 16,
                      ),
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: giamSoNgay,
                        iconSize: 16,
                      ),
                    ],
                  ),
                ),
              ),

              //---------------------2 ô này lấy dữ liệu từ database---------------------

              TableCell(
                child: Container(
                  height: 40, // Set the height of the row
                  child: Center(
                    child: Text(
                      humidity.toString(),
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16, // Set the font size
                        fontWeight: FontWeight.bold, // Set the font weight
                      ),
                    ),
                  ),
                ),
              ),

              TableCell(
                child: Container(
                  height: 40, // Set the height of the row
                  child: Center(
                    child: Text(
                      lightIntensity.toString(),
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16, // Set the font size
                        fontWeight: FontWeight.bold, // Set the font weight
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
