// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:live_streaming/src/utils/constants/m_key.dart';
// import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart';
//
// import '../../../../model/response/message_model.dart';
//
// class DatabaseHelper{
//   static final DatabaseHelper instance = DatabaseHelper._init();
//   Database? _database;
//
//   DatabaseHelper._init();
//
//   Future<Database> get database async{
//     if(_database != null) {
//       return _database!;
//     }
//
//     _database = await _initDB('lovorise.db');
//     return _database!;
//   }
//
//   Future<Database> _initDB(String filePath)async{
//     final dbPath = await getDatabasesPath();
//     final path = join(dbPath, filePath);
//
//     return await openDatabase(path, version: 1, onCreate: _createDB, onUpgrade: _upgradeDB);
//   }
//
//   Future _createDB(Database db, int version)async{
//     await db.execute('''
//       create table ${MyKey.messageTableName}(
//       id integer primary key autoincrement,
//       messageId text,
//       name text not null,
//       photo text,
//       isActive boolean not null,
//       userId text,
//       message text,
//       lastMessage text,
//       count integer,
//       isMe boolean not null,
//       replyMsg text,
//       type integer,
//       createdAt text,
//       updatedAt text not null)
//     ''');
//
//     await db.execute('''
//       create table ${MyKey.rosterTableName}(
//       id integer primary key autoincrement,
//       name text not null,
//       photo text,
//       isActive boolean not null,
//       userId text,
//       messageId text,
//       lastMessage text,
//       count integer,
//       createdAt text,
//       updatedAt text not null)
//     ''');
//   }
//
//   Future<void> _upgradeDB(Database db, int oldVersion, int newVersion)async{
//     if(oldVersion < 2){
//       print("Need to Update DB");
//     }
//   }
//
//   Future<void> insert({required MessageModel messageModel})async{
//     try{
//       final db = await instance.database;
//
//       await db.insert(MyKey.messageTableName, messageModel.toJson());
//     }catch(e){
//       print(e.toString());
//     }
//   }
//
//   Future<void> insertRoster({required RosterMessageModel rosterMessageModel})async{
//     try{
//       final db = await instance.database;
//
//       //check if a row with the same userId
//       List<Map<String, dynamic>> existingRows = await db.query(
//         MyKey.rosterTableName,
//         where: 'userId = ?',
//         whereArgs: [rosterMessageModel.userId],
//       );
//
//       if (existingRows.isNotEmpty) {
//         // If a row exists, update it
//         await db.update(
//           MyKey.rosterTableName,
//           rosterMessageModel.toJson(),
//           where: 'userId = ?',
//           whereArgs: [rosterMessageModel.userId],
//         );
//       } else {
//         // If no row exists, insert a new row
//         await db.insert(MyKey.rosterTableName, rosterMessageModel.toJson());
//       }
//
//     }catch(e){
//       print(e.toString());
//     }
//   }
//
//   List<MessageModel> messageList = [];
//
//   Future<List<MessageModel>> getMessagesByUserId(String userId, int pageNumber, int itemPerPage, bool reload)async{
//     try{
//       final db = await instance.database;
//       final offset = ((pageNumber - 1) * itemPerPage);
//
//       final List<Map<String, dynamic>> maps =  await db.query(
//         MyKey.messageTableName,
//         where: 'userId = ?',
//         whereArgs: [userId],
//         orderBy: 'id Desc',
//         limit: itemPerPage,
//         offset: offset,
//       );
//
//       if(reload){
//         messageList = [];
//       }
//
//       maps.reversed.toList();
//       // debugPrint("***** ${maps.length} withUserId $userId t0UserId $ownUserId pageNumber $pageNumber");
//
//       for(final map in maps){
//         final message = MessageModel.fromJson(map);
//         messageList.add(message);
//       }
//       return messageList.reversed.toList();
//     }catch(e){
//       print("Error Retrieving Chat "+e.toString());
//     }
//
//
//     return messageList;
//   }
//
//   Future<void> deleteMessagesByUserId(String withUserId)async{
//
//     try{
//       final db = await instance.database;
//       await db.delete(
//         MyKey.messageTableName,
//         where: 'userId = ?',
//         whereArgs: [withUserId],
//       );
//
//     }catch(e){
//       print("Error Retrieving Chat "+e.toString());
//     }
//   }
//
//   Future<void> deleteRosterByUserId(String withUserId)async{
//
//     try{
//       final db = await instance.database;
//       await db.delete(
//         MyKey.rosterTableName,
//         where: 'userId = ?',
//         whereArgs: [withUserId],
//       );
//
//     }catch(e){
//       print("Error Retrieving Chat "+e.toString());
//     }
//   }
//
//   Future<void> deleteAllMessages()async{
//
//     try{
//       final db = await instance.database;
//       await db.delete(
//         MyKey.messageTableName
//       );
//
//     }catch(e){
//       print("Error Retrieving Chat "+e.toString());
//     }
//   }
//
//   Future<void> deleteAllRosters()async{
//
//     try{
//       final db = await instance.database;
//       await db.delete(
//           MyKey.rosterTableName
//       );
//
//     }catch(e){
//       print("Error Retrieving Chat "+e.toString());
//     }
//   }
//
//
//   List<RosterMessageModel> chatList = [];
//   Future<List<RosterMessageModel>> getChatList(int pageNumber,String ownUserId, int itemPerPage, bool reload)async{
//
//     try{
//       final db = await instance.database;
//       final offset = (pageNumber - 1) * itemPerPage;
//
//       final List<Map<String, dynamic>> maps =  await db.query(
//         groupBy: 'name',
//         MyKey.rosterTableName,
//         having: 'createdAt = MAX(createdAt)',
//         orderBy: 'createdAt ASC',
//         limit: itemPerPage,
//         offset: offset,
//       );
//
//
//       if(reload){
//         chatList = [];
//       }
//       for(final map in maps){
//         final message = RosterMessageModel.fromJson(map);
//
//        // final countResult = await db.rawQuery('SELECT COUNT(*) as count FROM ${MyKey.messageTableName}');
//
//        // message.count = Sqflite.firstIntValue(countResult);
//
//         // debugPrint("***** RosterList ${json.encode(message)}");
//
//         chatList.add(message);
//       }
//
//       return chatList.reversed.toList();
//     }catch(e){
//       print("Error Retrieving Chat "+e.toString());
//     }
//
//     return chatList;
//   }
//
//   // List<MessageModel> requestList = [];
//   // Future<List<MessageModel>> getRequestChatList(int pageNumber,String ownUserId,bool isRequest, int itemPerPage, bool reload)async{
//   //   try{
//   //     final db = await instance.database;
//   //     final offset = (pageNumber - 1) * itemPerPage;
//   //
//   //     final List<Map<String, dynamic>> maps =  await db.query(
//   //       groupBy: 'name',
//   //       ApiConfig.messageTableName,
//   //       where: 'toUserId = ? AND isRequest = ?',
//   //       whereArgs: [ownUserId, isRequest],
//   //       having: 'createdAt = MAX(createdAt)',
//   //       orderBy: 'createdAt ASC',
//   //       limit: itemPerPage,
//   //       offset: offset,
//   //     );
//   //
//   //
//   //     if(reload){
//   //       requestList = [];
//   //     }
//   //     for(final map in maps){
//   //       final message = MessageModel.fromJson(map);
//   //
//   //       final countResult = await db.rawQuery(
//   //           'SELECT COUNT(*) as count FROM ${ApiConfig.messageTableName} WHERE withUserId = ? AND isSeen = ?',
//   //           [message.withUserId, false]
//   //       );
//   //
//   //       message.unreadMessageCount = Sqflite.firstIntValue(countResult);
//   //
//   //       requestList.add(message);
//   //     }
//   //
//   //     return requestList.reversed.toList();
//   //   }catch(e){
//   //     print("Error Retrieving Chat "+e.toString());
//   //   }
//   //
//   //   return requestList;
//   // }
//   //
//   // Future<bool> getUnreadMessage(String toUserId)async{
//   //   try{
//   //     final db = await instance.database;
//   //     // Check unread Message
//   //     final unreadMessageCount = await db.rawQuery(
//   //         'SELECT COUNT(*) FROM ${ApiConfig.messageTableName} WHERE toUserId = ? AND isSeen = ?',
//   //         [toUserId, 0]
//   //     );
//   //
//   //     if(Sqflite.firstIntValue(unreadMessageCount) != null && Sqflite.firstIntValue(unreadMessageCount)! > 0){
//   //       return true;
//   //     }
//   //
//   //
//   //     return false;
//   //   }catch(e){
//   //     print(e.toString());
//   //     return false;
//   //   }
//   // }
//   //
//   // Future<void> updateRequest(String withUserId,)async{
//   //   try{
//   //     final db = await instance.database;
//   //
//   //     // the value need to update
//   //     final updateValue = {
//   //       'isRequest': 0,
//   //     };
//   //
//   //     // Perform the update
//   //     await db.update(
//   //       ApiConfig.messageTableName,
//   //       updateValue,
//   //       where: 'withUserId = ? AND isRequest = ?',
//   //       whereArgs: [withUserId, 1],
//   //     );
//   //   }catch(e){
//   //     debugPrint(e.toString());
//   //   }
//   // }
//   //
//   // Future<void> updateIsActive(String withUserId,bool isActive)async{
//   //   try{
//   //     final db = await instance.database;
//   //
//   //     // the value need to update
//   //     final updateValue = {
//   //       'isActive': isActive,
//   //     };
//   //
//   //     // Perform the update
//   //     await db.update(
//   //       ApiConfig.messageTableName,
//   //       updateValue,
//   //       where: 'withUserId = ?',
//   //       whereArgs: [withUserId],
//   //     );
//   //   }catch(e){
//   //     debugPrint(e.toString());
//   //   }
//   // }
//   //
//   // Future<void> updatePhoto(String withUserId,String photo)async{
//   //   try{
//   //     final db = await instance.database;
//   //
//   //     // the value need to update
//   //     final updateValue = {
//   //       'photo': photo,
//   //     };
//   //
//   //     // Perform the update
//   //     await db.update(
//   //       ApiConfig.messageTableName,
//   //       updateValue,
//   //       where: 'withUserId = ?',
//   //       whereArgs: [withUserId],
//   //     );
//   //   }catch(e){
//   //     debugPrint(e.toString());
//   //   }
//   // }
//   //
//   // Future<void> updateIsSeen(String withUserId,)async{
//   //   try{
//   //     final db = await instance.database;
//   //
//   //     // the value need to update
//   //     final updateValue = {
//   //       'isSeen': 1,
//   //     };
//   //
//   //     // Perform the update
//   //
//   //     await db.update(
//   //       ApiConfig.messageTableName,
//   //       updateValue,
//   //       where: 'withUserId = ? AND isSeen = ?',
//   //       whereArgs: [withUserId, 0],
//   //     );
//   //   }catch(e){
//   //     debugPrint(e.toString());
//   //   }
//   // }
//   //
//   // Future<void> updateBlockedByMe(String toUserId, String withUserId, bool blocked)async{
//   //   try{
//   //     final db = await instance.database;
//   //
//   //     // the value need to update
//   //     final updateValue = {
//   //       'isBlockedByMe': blocked,
//   //       'isActive': !blocked,
//   //     };
//   //
//   //     // Perform the update
//   //
//   //     await db.update(
//   //       ApiConfig.messageTableName,
//   //       updateValue,
//   //       where: 'toUserId = ? AND withUserId = ?',
//   //       whereArgs: [toUserId, withUserId],
//   //     );
//   //   }catch(e){
//   //     debugPrint(e.toString());
//   //   }
//   // }
// }