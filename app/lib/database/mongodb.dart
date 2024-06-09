import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:flutter/foundation.dart';

class DatabaseManager extends ChangeNotifier {
  late mongo.Db db;
  late mongo.DbCollection collection;

  Future<void> connectToDatabase() async {
    db = await mongo.Db.create(
        "mongodb+srv://myuser:myuser@cluster1.eqcvw4o.mongodb.net/?retryWrites=true&w=majority&appName=Cluster1");
    await db.open();
    if (db.isConnected) {
      print("Connected to database");
      collection = db.collection('Iot_final');
    } else {
      print("Error occurred and cannot connect to database");
    }
  }

  Future<bool> stateConnection() async {
    return db.isConnected;
  }

  Future cleanupDatabase() async {
    await db.close();
  }

  Future<double?> findHumidityValue() async {
    // Ensure collection is initialized before accessing it

    var res = await collection.findOne(mongo.where.eq('name', 'motor'));
    if (res != null && res.containsKey('humidity')) {
      return res['humidity'] as double?;
    } else {
      print('not found humidit5y');
      return null;
    }
  }

  Future<double?> findLightIntensityValue() async {
    var res = await collection.findOne(mongo.where.eq('name', 'bulb'));

    if (res != null && res.containsKey('light_intensity')) {
      return res['light_intensity'] as double?;
    } else {
      print('not found light_intensity');
      return null;
    }
  }

  Future<void> changeBulb2ON() async {
    var res = await collection.updateOne(
        mongo.where.eq('name', 'bulb'), mongo.modify.set('state', 'ON'),
        writeConcern: const mongo.WriteConcern(w: 'majority', wtimeout: 5000));
    print('Modified documents: ${res.nModified}'); // 1
  }

  Future<void> changeBulb2OFF() async {
    var res = await collection.updateOne(
        mongo.where.eq('name', 'bulb'), mongo.modify.set('state', 'OFF'),
        writeConcern: const mongo.WriteConcern(w: 'majority', wtimeout: 5000));
    print('Modified documents: ${res.nModified}'); // 1
  }

  Future<void> changeMotor2ON() async {
    var res = await collection.updateOne(
        mongo.where.eq('name', 'motor'), mongo.modify.set('state', 'ON'),
        writeConcern: const mongo.WriteConcern(w: 'majority', wtimeout: 5000));
    print('Modified documents: ${res.nModified}'); // 1
  }

  Future<void> changeMotor2OFF() async {
    var res = await collection.updateOne(
        mongo.where.eq('name', 'motor'), mongo.modify.set('state', 'OFF'),
        writeConcern: const mongo.WriteConcern(w: 'majority', wtimeout: 5000));
    print('Modified documents: ${res.nModified}'); // 1
  }
}
