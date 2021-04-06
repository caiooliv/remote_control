import 'package:flutter/material.dart';
import 'package:remote_front/MousePainter.dart';
import 'dart:async';
import 'package:remote_front/service/socketHandler.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _offsets = <Offset>[];
  final keyboardController = TextEditingController();
  final timeout = const Duration(seconds: 2);
  bool isTextVisible = false;
  FocusNode myFocusNode;
  Color pickerColor;
  Color currentColor = Color(0xff443a49);
  SocketHandler socketHandler = new SocketHandler();
  int oldTextLenght = 0;

  @override
  void initState() {
    super.initState();
    myFocusNode = FocusNode();
  }

  _getMouseMovement() {
    var i = _offsets.length - 3;
    var initalX = _offsets[0].dx;
    var initalY = _offsets[0].dy;

    var finalX = _offsets[i].dx;
    var finalY = _offsets[i].dx;

    var distance = {
      "x": finalX - initalX,
      "y": finalY - initalY,
    };

    return (distance);
  }

  @override
  void dispose() {
    keyboardController.dispose();
    socketHandler.disconnectSocket();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    toogleKeyboard() {
      isTextVisible = !isTextVisible;
    }

    removeFromOffests() {
      Timer.periodic(new Duration(milliseconds: 25), (timer) {
        if (_offsets.length == 0) {
          timer.cancel();
        } else {
          setState(() {
            _offsets.removeAt(0);
          });
        }
      });
    }

    changeColor(Color color) {
      setState(() => pickerColor = color);
    }

    _getUpdatePosition() {
      var i = _offsets.length - 2;

      var finalOffset = (_offsets.last - _offsets[i]);
      var distance = {
        "x": finalOffset.dx,
        "y": finalOffset.dy,
      };
      return distance;
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.color_lens),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Select Color'),
                    actions: [
                      TextButton(
                          onPressed: () {
                            setState(() => pickerColor = null);
                            Navigator.pop(context);
                          },
                          child: Text('🌈')),
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Ok')),
                    ],
                    content: SingleChildScrollView(
                      child: BlockPicker(
                        pickerColor: currentColor,
                        onColorChanged: changeColor,
                      ),
                    ),
                  );
                },
              );
            }),
        actions: [
          IconButton(
              icon: Icon(Icons.keyboard),
              onPressed: () {
                setState(() {
                  toogleKeyboard();
                  myFocusNode.requestFocus();
                });
              })
        ],
        title: Text('Remote control'),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              child: FittedBox(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.75,
                  width: MediaQuery.of(context).size.width,
                  child: ClipRect(
                    child: GestureDetector(
                      onPanDown: (details) {
                        this.setState(() {
                          _offsets.clear();
                          _offsets.add(details.localPosition);
                        });

                        Timer timer =
                            new Timer(new Duration(milliseconds: 500), () {
                          removeFromOffests();
                        });
                      },
                      onPanUpdate: (details) {
                        this.setState(() {
                          print(details.localPosition);
                          _offsets.add(details.localPosition);
                          var distance = _getUpdatePosition();
                          socketHandler.moveMouse(distance['x'], distance['y']);
                        });
                      },
                      onPanEnd: (details) {
                        this.setState(() {
                          _offsets.add(null);
                        });
                      },
                      child: CustomPaint(
                        painter: MousePainter(this._offsets,
                            pickedColor: pickerColor),
                        child: Container(
                          height: 200,
                          width: 200,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              height: MediaQuery.of(context).size.height * 0.75,
            ),
            Visibility(
              visible: isTextVisible,
              child: TextField(
                autocorrect: false,
                enableSuggestions: false,
                style: TextStyle(
                  color: Colors.transparent,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.black87,
                  disabledBorder: InputBorder.none,
                ),
                controller: keyboardController,
                focusNode: myFocusNode,
                onChanged: (text) {
                  var textLength = text.length;

                  if (textLength < oldTextLenght || textLength <= 0) {
                    socketHandler.typeKey('backspace', '');
                  } else {
                    if (text[textLength - 1].toUpperCase() ==
                        text[textLength - 1]) {
                      socketHandler.typeKey(text[textLength - 1], 'shift');
                    } else {
                      socketHandler.typeKey(text[textLength - 1], '');
                    }
                  }
                  oldTextLenght = textLength;
                },
                onEditingComplete: () {
                  keyboardController.text = '';
                  oldTextLenght = 0;
                  FocusScopeNode currentFocus = FocusScope.of(context);
                  if (!currentFocus.hasPrimaryFocus) {
                    currentFocus.unfocus();
                    toogleKeyboard();
                  }
                },
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.black,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      flex: 3,
                      child: GestureDetector(
                        onTap: () {
                          socketHandler.clickButtton('left');
                        },
                        child: Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.white54),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      flex: 3,
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          socketHandler.clickButtton('right');
                        },
                        child: Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.white54),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
