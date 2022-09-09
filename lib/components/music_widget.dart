import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:sound_flex/gen/assets.gen.dart';
import 'package:sound_flex/models/song_list.dart';
import 'package:sound_flex/utils/toasts.dart';

import 'package:audio_session/audio_session.dart';
import '../AppUrl/app_url.dart';
import '../view_models/auth_provider.dart';
import '../view_models/manager.dart';

class SongWidget extends StatelessWidget {
  final SongList? songList;
  final PageManager? pageManager;

  SongWidget({Key? key, required this.songList, required this.pageManager})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);

    // ignore: prefer_function_declarations_over_variables
    var tempLink = (String path) async {
      final Map<String, dynamic> getTempLink = {"path": path};
      final Future<Map<String, dynamic>> respose =
          authProvider.postRequest(getTempLink, AppUrl.tempLink);
      respose.then((response) async {
        if (response['status'] == null) {
          ToastService().showError(context, 'Failed', response['message']);
        }
        if (response['status'] == true) {
          //  _pageManager = PageManager(context);
          pageManager!.setPlay(context);
          ToastService().showSuccess(context, 'Success', response['message']);
        } else {
          ToastService().showError(context, 'Failed', response['message']);
        }
      });
    };
    return ListView.builder(
        shrinkWrap: true,
        itemCount: songList!.entries!.length,
        itemBuilder: (context, index) {
          SongInfo song = songList!.entries![index];
          // if (song.displayName.contains(".mp3"))
          return InkWell(
            onTap: () {
              pageManager!.setIndexSelected(index);
              print("selected index: $index");
              tempLink(song.pathLower!);
            },
            child: Card(
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: ClipRRect(
                        child: Assets.images.disc.image(
                          height: 40,
                          width: 40,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              flex: 4,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(song.name!,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700)),
                                  const Text("Release Year: year",
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w500)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}

class IconText extends StatelessWidget {
  final IconData? iconData;
  final String? string;
  final Color? iconColor;
  final Color? textColor;
  final double? iconSize;

  const IconText({
    @required this.textColor,
    @required this.iconColor,
    @required this.string,
    @required this.iconSize,
    @required this.iconData,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Icon(
          iconData,
          size: iconSize,
          color: iconColor,
        ),
        const SizedBox(
          height: 8,
        ),
        const Text(
          "",
          style: TextStyle(
              color: Colors.red, fontSize: 10, fontWeight: FontWeight.w900),
        ),
      ],
    );
  }
}
