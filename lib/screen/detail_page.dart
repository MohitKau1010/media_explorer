import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:media_explorer/widget/video_widget.dart';
import 'package:oktoast/oktoast.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class DetailPage extends StatefulWidget {
  final AssetEntity entity;
  final String mediaUrl;

  //final List<String> imagePaths;
  //final int currentIndex;

  const DetailPage({
    Key key,
    this.entity,
    this.mediaUrl,
  }) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  bool useOrigin = true;
  int _currentIndex;
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _currentIndex = 0; //widget.currentIndex;
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    final originCheckbox = CheckboxListTile(
      title: Text("Use origin file."),
      onChanged: (value) {
        this.useOrigin = value;
        setState(() {

        });
      },
      value: useOrigin,
    );
    final children = <Widget>[
      Container(
        color: Colors.black,
        child: _buildContent(),
      ),
    ];


    /// if asset type is image then show checkbox on top at(0)
    if (widget.entity.type == AssetType.image) {
      // children.insert(0, originCheckbox); ///
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Asset detail"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.info),
            onPressed: _showInfo,
          ),
        ],
      ),
      body: Container(
        color: Colors.black,
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 95.0),
          child: Container(
            color: Colors.black,
            child: _buildContent(),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (widget.entity.type == AssetType.video) {
      return buildVideo();
    } else if (widget.entity.type == AssetType.audio) {
      return buildVideo();
    } else {
      return buildImage();
    }
  }

  Widget buildImage() {
    return FutureBuilder<File>(
      future: useOrigin ? widget.entity.originFile : widget.entity.file,
      builder: (_, snapshot) {
        if (snapshot.data == null) {
          return Center(
            child: SizedBox(
              width: 30,
              height: 30,
              child: CircularProgressIndicator(),
            ),
          );
        }
        return Image.file(
            snapshot.data); //_buildPhotoViewGallery(snapshot.data);//Image.file(snapshot.data);  //
      },
    );
  }

  PhotoViewGallery _buildPhotoViewGallery(File data) {
    //Uint8List bytes = base64Decode(data.toString());
    ImageProvider imageProvider = FileImage(File(data.path));

    return PhotoViewGallery.builder(
      itemCount: 0,
      //widget.imagePaths.length,
      builder: (BuildContext context, int index) {
        return PhotoViewGalleryPageOptions(
          imageProvider: imageProvider,
          minScale: PhotoViewComputedScale.contained * 0.8,
          maxScale: PhotoViewComputedScale.covered * 1.8,
        );
      },
      enableRotation: true,
      scrollPhysics: const BouncingScrollPhysics(),
      pageController: _pageController,
      loadingBuilder: (BuildContext context, ImageChunkEvent event) {
        return Center(child: CircularProgressIndicator());
      },
      onPageChanged: (int index) {
        setState(() {
          _currentIndex = index;
        });
      },
    );
  }

  Widget buildVideo() {
    return VideoWidget(
      isAudio: widget.entity.type == AssetType.audio,
      mediaUrl: widget.mediaUrl,
    );
  }

  void _showInfo() async {
    final entity = widget.entity;

    final latlng = await entity.latlngAsync();

    final lat = entity.latitude == 0 ? latlng.latitude : latlng.latitude;
    final lng = entity.longitude == 0 ? latlng.longitude : latlng.longitude;

    Widget w = Center(
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(15),
        child: Material(
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              GestureDetector(
                child: buildInfoItem("id", entity.id),
                onLongPress: () {
                  Clipboard.setData(ClipboardData(text: entity.id));
                  showToast('The id already copied.');
                },
              ),
              buildInfoItem("create", entity.createDateTime.toString()),
              buildInfoItem("modified", entity.modifiedDateTime.toString()),
              buildInfoItem("size", entity.size.toString()),
              buildInfoItem("orientation", entity.orientation.toString()),
              buildInfoItem("duration", entity.videoDuration.toString()),
              buildInfoItemAsync("title", entity.titleAsync),
              buildInfoItem("lat", lat?.toString() ?? "null"),
              buildInfoItem("lng", lng?.toString() ?? "null"),
              buildInfoItem("relative path", entity.relativePath ?? 'null'),
            ],
          ),
        ),
      ),
    );
    showDialog(context: context, builder: (c) => w);
  }

  Widget buildInfoItem(String title, String info) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              title.padLeft(10, " "),
              textAlign: TextAlign.start,
            ),
            width: 88,
          ),
          Expanded(
            child: Text(info.padLeft(40, " ")),
          ),
        ],
      ),
    );
  }

  Widget buildInfoItemAsync(String title, Future<String> info) {
    return FutureBuilder(
      future: info,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return buildInfoItem(title, "");
        }
        return buildInfoItem(title, snapshot.data);
      },
    );
  }

  Widget buildAudio() {
    return Container(
      child: Center(
        child: Icon(Icons.audiotrack),
      ),
    );
  }
}
