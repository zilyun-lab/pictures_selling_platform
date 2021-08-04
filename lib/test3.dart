import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:selling_pictures_platform/Store/product_page.dart';

import 'Models/AllProviders.dart';
import 'Models/item.dart';

class Test3 extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final count = useProvider(countStateProvider);
    final alls = ref.watch(allMainItemsStreamProvider);

    return MaterialApp(
      home: Scaffold(
        body: alls.when(
          data: (items) {
            return ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return ListTile(
                    leading: Image.network(item.thumbnailUrl),
                    title: Text(
                      item.shortInfo,
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (c) => ProductPage(item.id)));
                    },
                  );
                });
          },
          loading: () => const CircularProgressIndicator(),
          error: (error, stack) => Text('Error: $error'),
        ),
        // body: Center(
        //   child: Text(
        //     '$count',
        //     style: TextStyle(color: count ? Colors.red : Colors.blue),
        //   ),
        // ),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () =>
        //       context.read(countStateProvider.notifier).increment(),
        //   child: Icon(Icons.add),
        // ),
      ),
    );
  }
}
