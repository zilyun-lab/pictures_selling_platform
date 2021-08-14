// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:selling_pictures_platform/Models/all_providers.dart';
import 'package:selling_pictures_platform/Widgets/AllWidget.dart';
import 'package:selling_pictures_platform/Widgets/custom_app_bar.dart';

class MyUploadItems extends HookConsumerWidget {
  const MyUploadItems({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(myUploadItemStreamProvider);
    return Scaffold(
      backgroundColor: bgColor,
      appBar: MyAppBar(
        title: const Text('出品履歴'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 5, bottom: 8),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: SingleChildScrollView(
            child: items.when(
                data: (item) {
                  return GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    shrinkWrap: true,
                    itemCount: item.length,
                    itemBuilder: (context, index) {
                      return sourceInfoForMain(item[index], context);
                    },
                  );
                },
                loading: () => const CircularProgressIndicator(),
                error: (error, stack) => beginUpload(context)),
          ),
        ),
      ),
    );
  }

  Neumorphic beginUpload(BuildContext context) {
    return Neumorphic(
      style: NeumorphicStyle(color: bgColor),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.insert_emoticon,
              color: Colors.black,
            ),
            Text('まだ出品していません'),
            Text('何か出品してみませんか？'),
          ],
        ),
      ),
    );
  }
}
