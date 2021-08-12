import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:selling_pictures_platform/Config/config.dart';
import 'package:selling_pictures_platform/Models/user.dart';

import 'LikeItemsList.dart';
import 'chat_model.dart';
import 'item.dart';
import 'orders_model.dart';

final allMainItemsStreamProvider = StreamProvider<List<ItemModel>>((ref) {
  // users/{user.uid} ドキュメントのSnapshotを取得
  final collection = FirebaseFirestore.instance.collection('items').orderBy(
        "publishedDate",
        descending: true,
      );
  // データ（Map型）を取得
  final stream = collection.snapshots().map(
        // CollectionのデータからItemクラスを生成する
        (e) => e.docs.map((e) => ItemModel.fromJson(e.data())).toList(),
      );
  return stream;
});

final originalItemsStreamProvider = StreamProvider<List<ItemModel>>((ref) {
  // users/{user.uid} ドキュメントのSnapshotを取得
  final collection = FirebaseFirestore.instance
      .collection('items')
      .where("attribute", isEqualTo: "Original")
      .orderBy(
        "publishedDate",
        descending: true,
      );
  // データ（Map型）を取得
  final stream = collection.snapshots().map(
        // CollectionのデータからItemクラスを生成する
        (e) => e.docs.map((e) => ItemModel.fromJson(e.data())).toList(),
      );
  return stream;
});
final copyItemsStreamProvider = StreamProvider<List<ItemModel>>((ref) {
  // users/{user.uid} ドキュメントのSnapshotを取得
  final collection = FirebaseFirestore.instance
      .collection('items')
      .where("attribute", isEqualTo: "Copy")
      .orderBy(
        "publishedDate",
        descending: true,
      );
  // データ（Map型）を取得
  final stream = collection.snapshots().map(
        // CollectionのデータからItemクラスを生成する
        (e) => e.docs.map((e) => ItemModel.fromJson(e.data())).toList(),
      );
  return stream;
});
final stickerItemsStreamProvider = StreamProvider<List<ItemModel>>((ref) {
  // users/{user.uid} ドキュメントのSnapshotを取得
  final collection = FirebaseFirestore.instance
      .collection('items')
      .where("attribute", isEqualTo: "Sticker")
      .orderBy(
        "publishedDate",
        descending: true,
      );
  // データ（Map型）を取得
  final stream = collection.snapshots().map(
        // CollectionのデータからItemクラスを生成する
        (e) => e.docs.map((e) => ItemModel.fromJson(e.data())).toList(),
      );
  return stream;
});
final postCardItemsStreamProvider = StreamProvider<List<ItemModel>>((ref) {
  // users/{user.uid} ドキュメントのSnapshotを取得
  final collection = FirebaseFirestore.instance
      .collection('items')
      .where("attribute", isEqualTo: "PostCard")
      .orderBy(
        "publishedDate",
        descending: true,
      );
  // データ（Map型）を取得
  final stream = collection.snapshots().map(
        // CollectionのデータからItemクラスを生成する
        (e) => e.docs.map((e) => ItemModel.fromJson(e.data())).toList(),
      );
  return stream;
});

final specificIDItemsStreamProvider =
    StreamProvider.family<List<ItemModel>, String>((ref, id) {
  // users/{user.uid} ドキュメントのSnapshotを取得
  final collection =
      FirebaseFirestore.instance.collection('items').where("id", isEqualTo: id);
  // データ（Map型）を取得
  final stream = collection.snapshots().map(
        // CollectionのデータからItemクラスを生成する
        (e) => e.docs.map((e) => ItemModel.fromJson(e.data())).toList(),
      );
  return stream;
});
final specificIDItemsImageStreamProvider =
    StreamProvider.family<List<ItemModel>, String>((ref, id) {
  final collection = FirebaseFirestore.instance
      .collection('items')
      .doc(id)
      .collection("itemImages");
  final stream = collection.snapshots().map(
        (e) => e.docs.map((e) => ItemModel.fromJson(e.data())).toList(),
      );
  return stream;
});
final likeItemStreamProvider = StreamProvider<List<LikeItems>>((ref) {
  final collection = FirebaseFirestore.instance.collection("items").where("id",
      whereIn: EcommerceApp.sharedPreferences
          .getStringList(EcommerceApp.userLikeList));
  final stream = collection.snapshots().map(
        (e) => e.docs.map((e) => LikeItems.fromJson(e.data())).toList(),
      );
  return stream;
});
final userInfoStreamProvider = StreamProvider<List<User>>((ref) {
  final collection = FirebaseFirestore.instance.collection("users").where("uid",
      isEqualTo:
          EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID));
  final stream = collection.snapshots().map(
        (e) => e.docs.map((e) => User.fromJson(e.data())).toList(),
      );
  return stream;
});

final searchByWordStreamProvider =
    StreamProvider.family<List<ItemModel>, String>((ref, query) {
  // users/{user.uid} ドキュメントのSnapshotを取得
  final collection = FirebaseFirestore.instance
      .collection('items')
      .where("shortInfo", isGreaterThanOrEqualTo: query);
  // データ（Map型）を取得
  final stream = collection.snapshots().map(
        // CollectionのデータからItemクラスを生成する
        (e) => e.docs.map((e) => ItemModel.fromJson(e.data())).toList(),
      );
  return stream;
});

final searchByPriceStreamProvider =
    StreamProvider.family<List<ItemModel>, double>((ref, priceQuery) {
  // users/{user.uid} ドキュメントのSnapshotを取得
  final collection = FirebaseFirestore.instance
      .collection('items')
      .where("price", isLessThanOrEqualTo: priceQuery);
  // データ（Map型）を取得
  final stream = collection.snapshots().map(
        // CollectionのデータからItemクラスを生成する
        (e) => e.docs.map((e) => ItemModel.fromJson(e.data())).toList(),
      );
  return stream;
});

final searchByColorStreamProvider =
    StreamProvider.family<List<ItemModel>, String>((ref, query) {
  // users/{user.uid} ドキュメントのSnapshotを取得
  final collection = FirebaseFirestore.instance
      .collection('items')
      .where("color1", isGreaterThanOrEqualTo: query);
  // データ（Map型）を取得
  final stream = collection.snapshots().map(
        // CollectionのデータからItemクラスを生成する
        (e) => e.docs.map((e) => ItemModel.fromJson(e.data())).toList(),
      );
  return stream;
});
final myUploadItemStreamProvider = StreamProvider<List<ItemModel>>((ref) {
  final collection = FirebaseFirestore.instance
      .collection("users")
      .doc(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
      .collection("MyUploadItems");

  final stream = collection.snapshots().map(
        (e) => e.docs.map((e) => ItemModel.fromJson(e.data())).toList(),
      );
  return stream;
});
final orderWithIDStreamProvider =
    StreamProvider.family<List<Orders>, String>((ref, orderID) {
  final collection = FirebaseFirestore.instance
      .collection("orders")
      .where("id", isEqualTo: orderID);

  final stream = collection.snapshots().map(
        (e) => e.docs.map((e) => Orders.fromJson(e.data())).toList(),
      );
  return stream;
});
final chatStreamProvider = StreamProvider<List<Chat>>((ref) {
  final collection = FirebaseFirestore.instance
      .collection("users")
      .doc(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
      .collection("chat")
      .orderBy("created_at", descending: true);

  final stream = collection.snapshots().map(
        (e) => e.docs.map((e) => Chat.fromJson(e.data())).toList(),
      );
  return stream;
});

final ordersStreamProvider = StreamProvider<List<Orders>>((ref) {
  final collection = FirebaseFirestore.instance.collection("orders");

  final stream = collection.snapshots().map(
        (e) => e.docs.map((e) => Orders.fromJson(e.data())).toList(),
      );
  return stream;
});
