import 'dart:io';

import 'package:flutter/material.dart';
import 'package:media_explorer/screen/image_list_page.dart';
import 'package:media_explorer/widget/list_dialog.dart';
import 'package:oktoast/oktoast.dart';
import 'package:photo_manager/photo_manager.dart';

class GalleryItemWidget extends StatelessWidget {
  final AssetPathEntity path;
  final ValueSetter<VoidCallback> setState;

  const GalleryItemWidget({
    Key key,
    this.path,
    this.setState,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return buildGalleryItemWidget(path, context);
  }

  Widget buildGalleryItemWidget(AssetPathEntity item, BuildContext context) {
    return GestureDetector(
      child: ListTile(
        title: Text(item.name +'(${item.assetCount})'),
        //subtitle: Text("count : ${item.assetCount}"),
        //trailing: _buildSubButton(item),
      ),
      onTap: () {
        if (item.assetCount == 0) {
          showToast("The asset count is 0.");
          return;
        }
        if (item.albumType == 2) {
          showToast("The folder can't get asset");
          return;
        }

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => GalleryContentListPage(
              path: item,
            ),
          ),
        );
      },
      onLongPress: () async {
        showDialog(
          context: context,
          builder: (_) {
            return ListDialog(
              children: [
                RaisedButton(
                  child: Text("refresh properties"),
                  onPressed: () async {
                    await item.refreshPathProperties();
                    setState(() {});
                  },
                ),
                RaisedButton(
                  child: Text("Delete self (${item.name})"),
                  onPressed: () async {
                    if (!(Platform.isIOS || Platform.isMacOS)) {
                      showToast("The function only support iOS.");
                      return;
                    }
                    PhotoManager.editor.iOS.deletePath(path);
                  },
                ),
              ],
            );
          },
        );
      },
      // onDoubleTap: () async {
      //   final list =
      //       await item.getAssetListRange(start: 0, end: item.assetCount);
      //   for (var i = 0; i < list.length; i++) {
      //     final asset = list[i];
      //     debugPrint("$i : ${asset.id}");
      //   }
      // },
    );
  }

  Widget _buildSubButton(AssetPathEntity item) {
    if (item.isAll || item.albumType == 2) {
      return Builder(
        builder: (ctx) => RaisedButton(
          /*onPressed: () async {
            final sub = await item.getSubPathList();
            Navigator.push(ctx, MaterialPageRoute(builder: (_) {
              return SubFolderPage(
                title: item.name,
                pathList: sub,
              );
            }));
          },*/
          child: Text("folder"),
        ),
      );
    } else {
      return Container(
        width: 0,
        height: 0,
      );
    }
  }

}
