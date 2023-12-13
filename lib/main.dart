import 'package:flutter/material.dart';

void main() {
  runApp(ConvertApp());
}

class ConvertApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Unit Converter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ConvertScreen(),
    );
  }
}

class ConvertScreen extends StatelessWidget {
  final List<Unit> units = [
    Unit(
      name: 'Weight/Mass',
      icon: Icons.scale,
      conversion: [
        ConversionUnit(name: 'Gram', ratio: 1),
        ConversionUnit(name: 'Kilogram', ratio: 0.001),
        ConversionUnit(name: 'Pound', ratio: 0.00220462),
      ],
    ),
    Unit(
      name: 'Currency',
      icon: Icons.attach_money,
      conversion: [
        ConversionUnit(name: 'USD', ratio: 1),
        ConversionUnit(name: 'EUR', ratio: 0.84),
        ConversionUnit(name: 'GBP', ratio: 0.72),
      ],
    ),
    Unit(
      name: 'Temperature',
      icon: Icons.ac_unit,
      conversion: [
        ConversionUnit(name: 'Celsius', ratio: 1),
        ConversionUnit(name: 'Fahrenheit', ratio: 1.8),
        ConversionUnit(name: 'Kelvin', ratio: 1),
      ],
    ),
    Unit(
      name: 'Length',
      icon: Icons.straighten,
      conversion: [
        ConversionUnit(name: 'Meter', ratio: 1),
        ConversionUnit(name: 'Kilometer', ratio: 0.001),
        ConversionUnit(name: 'Mile', ratio: 0.000621371),
      ],
    ),
    Unit(
      name: 'Area',
      icon: Icons.crop_square,
      conversion: [
        ConversionUnit(name: 'Square Meter', ratio: 1),
        ConversionUnit(name: 'Square Kilometer', ratio: 0.000001),
        ConversionUnit(name: 'Square Mile', ratio: 0.000000386102),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Unit Converter'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: units.map((unit) => Column(
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                  onPrimary: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 5,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ConversionScreen(unit),
                    ),
                  );
                },
                child: Row(
                  children: [
                    Icon(unit.icon, color: Colors.white),
                    SizedBox(width: 10),
                    Text(unit.name),
                  ],
                ),
              ),
              SizedBox(height: 20),
            ],
          )).toList(),
        ),
      ),
    );
  }
}


class ConversionScreen extends StatefulWidget {
  final Unit unit;

  ConversionScreen(this.unit);

  @override
  _ConversionScreenState createState() => _ConversionScreenState();
}

class _ConversionScreenState extends State<ConversionScreen> {
  double inputValue = 0;
  ConversionUnit? fromUnit;
  ConversionUnit? toUnit;
  bool isInvalidOperation = false;
  String conversionResult = '';

  @override
  void initState() {
    super.initState();
    fromUnit = widget.unit.conversion[0];
    toUnit = widget.unit.conversion[1];
  }

  void convert() {
    double convertedValue = inputValue * (toUnit!.ratio / fromUnit!.ratio);
    convertedValue = double.parse(convertedValue.toStringAsFixed(2));
    setState(() {
      conversionResult = 'Result: $inputValue ${fromUnit!.name} = $convertedValue ${toUnit!.name}';
      isInvalidOperation = false;
    });
  }

  void swapUnits() {
    setState(() {
      ConversionUnit? tempUnit = fromUnit;
      fromUnit = toUnit;
      toUnit = tempUnit;
      convert();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.unit.name),
        ),
        body: Padding(
        padding: const EdgeInsets.all(16.0),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
    SizedBox(height: 20),
    Text('From:'),
    DropdownButton<ConversionUnit>(
    value: fromUnit,
    onChanged: (ConversionUnit? unit) {
    setState(() {
    fromUnit = unit!;
    convert();
    });
    },
      items: widget.unit.conversion.map<DropdownMenuItem<ConversionUnit>>(
            (ConversionUnit unit) => DropdownMenuItem<ConversionUnit>(
          value: unit,
          child: Text(unit.name),
        ),
      ).toList(),
    ),
      SizedBox(height: 20),
      Text('To:'),
      DropdownButton<ConversionUnit>(
        value: toUnit,
        onChanged: (ConversionUnit? unit) {
          setState(() {
            toUnit = unit!;
            convert();
          });
        },
        items: widget.unit.conversion.map<DropdownMenuItem<ConversionUnit>>(
              (ConversionUnit unit) => DropdownMenuItem<ConversionUnit>(
            value: unit,
            child: Text(unit.name),
          ),
        ).toList(),
      ),
      SizedBox(height: 40),
      Row(
        children: [
          Expanded(
            child: TextField(
              onChanged: (value) {
                setState(() {
                  inputValue = double.tryParse(value) ?? 0;
                });
              },
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Value',
              ),
            ),
          ),
          IconButton(
            onPressed: swapUnits,
            icon: Icon(Icons.swap_horiz),
          ),
        ],
      ),
      SizedBox(height: 40),
      ElevatedButton(
        onPressed: convert,
        child: Text('Convert'),
      ),
      SizedBox(height: 40),
      if (isInvalidOperation)
        Text(
          'Invalid operation: Division by zero',
          style: TextStyle(color: Colors.red),
        ),
      if (!isInvalidOperation) Text(conversionResult),
    ],
    ),
        ),
    );
  }
}

class Unit {
  final String name;
  final IconData icon;
  final List<ConversionUnit> conversion;

  Unit({
    required this.name,
    required this.icon,
    required this.conversion,
  });
}

class ConversionUnit {
  final String name;
  final double ratio;

  ConversionUnit({
    required this.name,
    required this.ratio,
  });
}