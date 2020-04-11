import "package:flutter/material.dart";

class AlphabetIndexPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Index"),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            ListTile(),
          ],
        ),
      ),
      body: Center(
        child: AlphabetIndex(),
      ),
      resizeToAvoidBottomPadding: true,
    );
  }
}

class AlphabetIndex extends StatefulWidget {
  @override
  AlphabetIndexPageState createState() => AlphabetIndexPageState();
}

class AlphabetIndexPageState extends State<AlphabetIndex> {
  final _searchBarController = TextEditingController();
  final _searchBarKey = GlobalKey<FormState>();

  List<String> _alphabet = new List<String>();

  Future<void> _buildAlertDialog(letter) {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return new Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            child: Container(
              height: 450,
              width: 300,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      letter,
                      style: TextStyle(
                          fontSize: 30.0, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(20.0)),
                      child: Image.network(
                        'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
                        fit: BoxFit.cover,
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes
                                  : null,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                  ),
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "Done",
                      style: TextStyle(fontSize: 20.0),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  Widget _buildCard(letter) {
    return new Container(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        width: double.maxFinite,
        height: 120,
        child: GestureDetector(
          onTap: () {
            _buildAlertDialog(letter);
          },
          child: Card(
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Align(
                alignment: Alignment.topCenter,
                child: Stack(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 10, top: 1.0),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 5.0, top: 5.0),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    letter,
                                    style: (TextStyle(fontSize: 60)),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 15.0, top: 5.0),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Tap Here to Display Hand Gesture",
                                    style: TextStyle(
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.w200),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  Widget _buildSearchBar() {
    return Container(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: _searchBarKey,
          child: TextFormField(
            controller: _searchBarController,
            onChanged: (value) {
              _onChanged(value);
            },
            onFieldSubmitted: (value) {
              _onSubmitted(value);
            },
            validator: (value) {
              if (value == null || value.isEmpty) return null;
              if (!_alphabet.contains(value)) {
                return "Sorry That Word/Character is Not Yet Supported";
              } else {
                return null;
              }
            },
            decoration: InputDecoration(
                hintText: "Search",
                contentPadding:
                    const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(32.0),
                    borderSide: BorderSide(color: Colors.blueAccent))),
          ),
        ));
  }

  void _onSubmitted(value) {
    FocusScope.of(context).requestFocus(new FocusNode());
    if (value == null || value.isEmpty) return;
    _buildAlertDialog(value);
  }

  // Update User on What Words/Chars are available
  void _onChanged(value) {
    if (!_searchBarKey.currentState.validate()) {
      return;
    }
  }

  // Load in Alphabet Characters
  void _loadAlphabet() {
    _alphabet.clear();
    for (int i = 65; i < 123; i++) {
      if (i > 90 && i < 97) continue;
      _alphabet.add(String.fromCharCode(i));
    }
  }

  @override
  Widget build(BuildContext context) {
    _loadAlphabet();
    return  Container(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: <Widget>[
            _buildSearchBar(),
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: _alphabet.length,
                itemBuilder: (BuildContext context, int index) {
                  return _buildCard(_alphabet[index]);
                },
              ),
            ),
          ],
        ),
    );
  }
}
