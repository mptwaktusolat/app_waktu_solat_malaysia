import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:waktusolatmalaysia/utils/AppInformation.dart';
import 'package:waktusolatmalaysia/utils/launchUrl.dart';

enum FeedbackCategory { suggestion, bug, compliment }

class FeedbackToEmail {
  String _emoji;
  String _feedbackType;
  String _message;
  String _debugLog;

  void emojiSetter(String emoji) {
    this._emoji = emoji;
  }

  void feedbackTypeSetter(String feedbackCategory) {
    this._feedbackType = feedbackCategory;
  }

  void messageSetter(String message) {
    this._message = message;
  }

  void debugLogSetter(String debugLog) {
    this._debugLog = debugLog;
  }

  void clearDebugLog() {
    this._debugLog = '';
  }

  String getAllData() {
    String data = '''$_emoji $_emoji $_emoji $_emoji $_emoji

    category: "$_feedbackType, "

    Message: $_message, 

    <---------Debug log:---------------
    $_debugLog
    ------------------EO🐛---------------->
    
    Thanks for ur feedback. Have a niceday.''';
    //add github issue link

    //EOF is end of feedback
    print(data);
    return data;
  }
}

class Feedmoji {
  bool isSelected;
  final String emojiText;

  Feedmoji(this.isSelected, this.emojiText);
}

class FeedbackPage extends StatefulWidget {
  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  AppInfo appInfo = AppInfo();
  FeedbackCategory feedbackCategory;
  double selectedOutlineWidth = 4.0;
  double unselectedOutlineWidth = 1.0;
  String hintTextForFeedback = 'Please leave your feedback below';
  List<Feedmoji> feedmoji = List<Feedmoji>();
  FeedbackToEmail feedbackToEmail = FeedbackToEmail();
  TextEditingController messageController = TextEditingController();
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  String board,
      brand,
      device,
      hardware,
      host,
      id,
      manufacture,
      model,
      product,
      type,
      androidid,
      sdkInt,
      release;
  bool isPhysicalDevice;

  @override
  void initState() {
    super.initState();
    feedmoji.add(Feedmoji(true, '😠'));
    feedmoji.add(Feedmoji(true, '🙁'));
    feedmoji.add(Feedmoji(true, '😐'));
    feedmoji.add(Feedmoji(true, '😄'));
    feedmoji.add(Feedmoji(true, '😍'));

    getDeviceInfo();
  }

  bool _logIsChecked = true;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text('Feedback'),
          centerTitle: true,
          actions: [
            IconButton(
                tooltip: 'Send via email',
                icon: Icon(Icons.send),
                onPressed: () {
                  print('Pressed send');
                  if (_logIsChecked) {
                    feedbackToEmail.debugLogSetter('''
                        ----------------------APP--------------------------
                        Version: ${appInfo.version}, VersionCode: ${appInfo.buildNumber}
                        ---------------------DEVICE---------------------
                        Android $release (SDK $sdkInt), $manufacture $model
                        Hardware: $hardware
                        Screen size ${MediaQuery.of(context).size.toString().substring(4)} DiP
                        PixRatio ${MediaQuery.of(context).devicePixelRatio}
                        Screen size (again) ${MediaQuery.of(context).size.toString().substring(4)} px
                    
                    ''');
                  }
                  feedbackToEmail.messageSetter(messageController.text);
                  feedbackToEmail.getAllData();
                  LaunchUrl.sendViaEmail(feedbackToEmail.getAllData());
                  FocusScope.of(context).unfocus();
                })
          ],
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('I would like to hear from you :)))'),
            Divider(
              height: 25.0,
            ),
            Text('What is your opinion for this app?'),
            Flexible(
              child: Container(
                height: 60,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: feedmoji.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          setState(
                            () {
                              feedmoji.forEach((element) {
                                element.isSelected = false;
                                feedmoji[index].isSelected = true;
                                feedbackToEmail
                                    .emojiSetter(feedmoji[index].emojiText);
                              });
                            },
                          );
                        },
                        child: EmojiReaction(feedmoji[index]),
                      );
                    }),
              ),
            ),
            Divider(),
            Text('Please select feedback category below'),
            SizedBox(
              height: 10.0,
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  FeedbackCategoryButton(
                    label: 'Suggestion',
                    outlineWidth:
                        feedbackCategory == FeedbackCategory.suggestion
                            ? selectedOutlineWidth
                            : unselectedOutlineWidth,
                    onTap: () {
                      setState(() {
                        feedbackCategory = FeedbackCategory.suggestion;
                        hintTextForFeedback = 'Urmm I\'ve a suggestion...';
                        feedbackToEmail.feedbackTypeSetter('Suggestion');
                      });
                    },
                    //THIS FILE IS THE MOST SPAGHETTI EVER
                  ),
                  FeedbackCategoryButton(
                    label: 'Something not quite right',
                    outlineWidth: feedbackCategory == FeedbackCategory.bug
                        ? selectedOutlineWidth
                        : unselectedOutlineWidth,
                    onTap: () {
                      setState(() {
                        feedbackCategory = FeedbackCategory.bug;
                        hintTextForFeedback = 'Eww I found a bug(s)';
                        feedbackToEmail
                            .feedbackTypeSetter('Something not quite right');
                      });
                    },
                  ),
                  FeedbackCategoryButton(
                    label: 'Compliment',
                    outlineWidth:
                        feedbackCategory == FeedbackCategory.compliment
                            ? selectedOutlineWidth
                            : unselectedOutlineWidth,
                    onTap: () {
                      setState(() {
                        feedbackCategory = FeedbackCategory.compliment;
                        hintTextForFeedback = 'haha write anything you want';
                        feedbackToEmail.feedbackTypeSetter('Compliment');
                      });
                    },
                  )
                ]),
            Divider(),
            Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                controller: messageController,
                decoration: InputDecoration(
                  hintText: hintTextForFeedback,
                  border: OutlineInputBorder(),
                ),
                // textInputAction: TextInputAction.done,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                maxLines: 4,
              ),
            ),
            Container(
              child: CheckboxListTile(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 0.0, vertical: 0),
                  controlAffinity: ListTileControlAffinity.leading,
                  title: Text(
                    'Include debug info (Recommended)',
                  ),
                  value: _logIsChecked,
                  onChanged: (value) {
                    setState(() {
                      _logIsChecked = value;
                      feedbackToEmail.clearDebugLog();
                    });
                  }),
            )
          ],
        ),
      ),
    );
  }

  void getDeviceInfo() async {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

    setState(() {
      board = androidInfo.board;
      brand = androidInfo.brand;
      device = androidInfo.device;
      hardware = androidInfo.hardware;
      host = androidInfo.host;
      id = androidInfo.id;
      manufacture = androidInfo.manufacturer;
      model = androidInfo.model;
      product = androidInfo.product;
      type = androidInfo.type;
      isPhysicalDevice = androidInfo.isPhysicalDevice;
      androidid = androidInfo.androidId;
      sdkInt = androidInfo.version.sdkInt.toString();
      release = androidInfo.version.release;
    });

    // print(
    //     '$board, $brand, $device, $hardware,\n $host, $id, $manufacture, $model,\n $product, $type, $isPhysicalDevice, $androidid \n $sdkInt, $release');
    // print(
    //     'Screen size ${MediaQuery.of(context).size} \n Screen h/w ${MediaQuery.of(context).size.height}, ${MediaQuery.of(context).size.width}');
    // print('Device pix ratio: ${MediaQuery.of(context).devicePixelRatio}');
    // print(
    //     '${MediaQuery.of(context).size * MediaQuery.of(context).devicePixelRatio}');
  }
}

class EmojiReaction extends StatelessWidget {
  EmojiReaction(this.feedmoji);
  final Feedmoji feedmoji;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Opacity(
        // opacity: 0.5,
        opacity: feedmoji.isSelected ? 1.0 : 0.37,
        child: Text(
          feedmoji.emojiText,
          style: TextStyle(fontSize: 30.0),
        ),
      ),
    );
  }
}

class FeedbackCategoryButton extends StatelessWidget {
  const FeedbackCategoryButton(
      {Key key, this.label, this.outlineWidth, this.onTap})
      : super(key: key);

  final label;
  final outlineWidth;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 65.0,
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: OutlineButton(
          onPressed: onTap,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          borderSide: BorderSide(color: Colors.green, width: outlineWidth),
          child: Text(
            label,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
