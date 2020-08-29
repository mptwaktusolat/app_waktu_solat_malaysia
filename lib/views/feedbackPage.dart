import 'package:flutter/material.dart';

class FeedbackPage extends StatefulWidget {
  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feedback'),
        actions: [
          FlatButton(
            onPressed: () {
              print('pressed send');
            },
            child: Text('Submit'),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('I would like to hear from you :)))'),
            Divider(
              height: 25.0,
            ),
            Text('What is your opinion of this app?'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  tooltip: 'naisu maple',
                  onPressed: () {
                    print('It is good');
                  },
                  icon: Icon(Icons.thumb_up, color: Colors.green.shade200),
                ),
                IconButton(
                  tooltip: 'meh',
                  onPressed: () {
                    print('It is meh');
                  },
                  icon: Icon(Icons.thumb_down, color: Colors.red.shade200),
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
              decoration: InputDecoration(hintText: 'Optional but recommended'),
            ),
          ],
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
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: OutlineButton(
          onPressed: () {
            print('pressed $label');
          },
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

//inspiration:
