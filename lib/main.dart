import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        // theme: ThemeData(primarySwatch: (genre) ? Colors.pink : Colors.blue,visualDensity: VisualDensity.adaptivePlatformDensity,),
        debugShowCheckedModeBanner: false,
        home: MyHomePage(title: 'Flutter Demo Home Page')
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState(title: title);
}

enum Frequence {faible, modere, forte }

class _MyHomePageState extends State<MyHomePage> {
  _MyHomePageState({this.title});

  String title;
  bool genre = true; // true : M & false : F
  DateTime date = null;
  double taille = null;
  double poids = null;

  // Map frequence = {'faible' : 1.2,'modere' : 1.5,'forte' : 1.8};

  @override
  Widget build(BuildContext context) {

    var app_height = MediaQuery.of(context).size.height;
    var app_width = MediaQuery.of(context).size.width;
    Frequence _freq = Frequence.modere;

    return Scaffold(
        appBar: AppBar(
          title: Text('Calorie app'),
          backgroundColor: (genre) ? Colors.blue : Colors.pink,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('Remplissez tous les champs pour obtenir vos besoins journalier en calories',
                textAlign: TextAlign.center,
              ),
              Container(
                height: app_height * 0.7,
                width: app_width * 0.9,
                child: Card(
                    child : Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text('Femme',
                              style: TextStyle(
                                color: Colors.pink
                              ),
                            ),
                            Switch(value: genre,
                                inactiveTrackColor: Colors.pink,
                                onChanged: (bool b) {
                                  setState(() {
                                    genre = b;
                                  });
                                }),
                            Text('Homme',
                              style: TextStyle(
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                        RaisedButton(
                            onPressed: selectDate,
                          child: Text((date == null ) ? 'Selection Date de Naissance' : date.toString(), style: TextStyle(color: Colors.white),),
                          color: (genre) ? Colors.blue : Colors.pink,
                        ),
                        Text('Votre taille est de  ${(taille == null ) ? '' : taille.toString()} cm',
                          style: TextStyle(
                            color: (genre) ? Colors.blue : Colors.pink
                          ),
                        ),
                        Slider(value: (taille == null) ? 150 : taille , onChanged: (val) => {
                          setState(() {
                           taille = val;
                          })
                        }, min: 130.0, max: 300.0, divisions: 170,
                          activeColor: (genre) ? Colors.blue : Colors.pink,
                          inactiveColor: (genre) ? Colors.blue[100] : Colors.pink[100],
                        ),
                        TextField(textAlign: TextAlign.center, keyboardType: TextInputType.number, onSubmitted: ((p) => {
                          setState(() {
                            poids = double.parse(p);
                          })
                        }),
                        decoration: InputDecoration(
                          labelText: 'Entrez votre poids en Kg'
                        ),),
                        Text('Quel est votre activité sportive ? '),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                Radio(value: Frequence.faible, groupValue : _freq, onChanged: (Frequence val) {
                                  setState(() {
                                    _freq = val;
                                  });
                                },
                                  activeColor: (genre)? Colors.blue : Colors.pink,
                                ),
                                Text('Faible'),
                              ],
                            ),
                            Column(
                              children: [
                                Radio(value: Frequence.modere, groupValue : _freq, onChanged: (Frequence val) {
                                  setState(() {
                                    _freq = val;
                                  });
                                },
                                  activeColor: (genre)? Colors.blue : Colors.pink,
                                ),
                                Text('Modérée'),
                              ],
                            ),
                            Column(
                              children: [
                                Radio(value: Frequence.forte, groupValue : _freq, onChanged: (Frequence val) {
                                  setState(() {
                                    _freq = val;
                                  });
                                },
                                  activeColor: (genre)? Colors.blue : Colors.pink,
                                ),
                                Text('Forte'),
                              ],
                            ),

                          ],
                        )

                      ],
                    ),
                  ),
                ),
              RaisedButton(onPressed: showCalorie,
                color: (genre) ? Colors.blue : Colors.pink,
                child: Text(
                  'Calculer',
                  style: TextStyle(color: Colors.white),
                ),

              )
            ],
          ),
        ),
    );
  }

  Future<Null> selectDate() async {
    DateTime myDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime.now()
    );

    setState(() {
      date = myDate;
    });
  }

  Future<void> showCalorie() async {

    var age = (DateTime.now().difference(date).inDays / 365).floor();
    print(age);

    var besoins = (genre) ? 66.4730 : 65.5095;
    besoins += (genre) ? 13.7516 * poids : 9.5634 * poids;
    besoins += (genre) ? 5.0033 * taille : 1.8496 * taille;
    besoins -= (genre) ? 4.7550 * age : 4.6756 * age;

    return showDialog(context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text('Vos besoins'),
          contentPadding: EdgeInsets.all(15),
          children: [
            Text('Vos besoins caloriques s\'élèvent à : $besoins ')
          ],
        );
      }
    );
  }

}
