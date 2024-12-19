import 'dart:math' as math show Random;
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'Testing Cubit',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    ),
  );
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // cubit is similar or one step up of stream and stream controller, so for initialize and close our cubit we need our Home page to state full widget

  late final Namescubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = Namescubit();
  }

  @override
  void dispose() {
    super.dispose();
    cubit.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
        backgroundColor: Colors.blue,
      ),
      body: StreamBuilder(
        stream: cubit.stream,
        builder: (context, snapshot) {
          final button = TextButton(
            onPressed: () {
              cubit.pickRandomName();
            },
            child: const Text("Pick Random"),
          );

          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return button;
            case ConnectionState.waiting:
              return button;
            case ConnectionState.active:
              return Column(
                children: [
                  Text(snapshot.data ?? ""),
                  button,
                ],
              );
            case ConnectionState.done:
              return const SizedBox();
          }
        },
      ),
    );
  }
}

const names = [
  'Foo',
  'Bar',
  "Baz",
];

extension RandomElement<T> on Iterable<T> {
  T getRandomElement() => elementAt(math.Random().nextInt(length));
}

class Namescubit extends Cubit<String?> {
  Namescubit() : super(null);

  void pickRandomName() => emit(
        names.getRandomElement(),
      );
}
