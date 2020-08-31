import 'package:flutter/material.dart';

class FeedbackPage extends StatefulWidget {
  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  bool _logIsChecked = true;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Feedback'),
          centerTitle: true,
          actions: [
            IconButton(
                tooltip: 'Send via email',
                icon: Icon(Icons.send),
                onPressed: () {
                  print('Pressed send');
                  FocusScope.of(context).unfocus();
                })
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('I would like to hear from you :)))'),
                  Divider(
                    height: 25.0,
                  ),
                  Text('What is your opinion of this app?'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      EmojiReaction(
                        emoji: '😠',
                      ),
                      EmojiReaction(
                        emoji: '🙁',
                      ),
                      EmojiReaction(
                        emoji: '😐',
                      ),
                      EmojiReaction(
                        emoji: '😄',
                      ),
                      EmojiReaction(
                        emoji: '😍',
                      ),
                    ],
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
                        ),
                        FeedbackCategoryButton(
                          label: 'Something not quite right',
                        ),
                        FeedbackCategoryButton(
                          label: 'Compliment',
                        )
                      ]),
                  Divider(),
                  Text('Please leave your feedback below'),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Optional but recommended',
                      border: OutlineInputBorder(),
                    ),
                    // textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.multiline,
                    maxLines: 4,
                  ),
                  Container(
                    child: CheckboxListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 0.0),
                        controlAffinity: ListTileControlAffinity.leading,
                        title: Text(
                          'Include debug info (Recommended)',
                        ),
                        value: _logIsChecked,
                        onChanged: (value) {
                          setState(() {
                            _logIsChecked = value;
                          });
                        }),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class EmojiReaction extends StatelessWidget {
  const EmojiReaction({Key key, this.emoji}) : super(key: key);

  final String emoji;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          print('happy');
        },
        child: Opacity(
          opacity: 1,
          child: Text(
            emoji,
            style: TextStyle(fontSize: 30.0),
          ),
        ),
      ),
    );
  }
}

class FeedbackCategoryButton extends StatelessWidget {
  const FeedbackCategoryButton({Key key, this.label}) : super(key: key);

  final label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 65.0,
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: OutlineButton(
          onPressed: () {
            print('pressed $label');
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          borderSide: BorderSide(color: Colors.green),
          child: Text(
            label,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
