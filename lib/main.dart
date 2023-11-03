import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // final counter = ref.read(counterProvider);

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final counter = ref.read(counterProvider);
    print('my home page');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Consumer(
              builder: (context, ref, _) {
                // final counter = ref.watch(counterProvider).counter;
                final asyncValue = ref.watch(streamProvider);
                return asyncValue.when(
                  data: (counter) {
                    return Text(
                      '$counter',
                      style: Theme.of(context).textTheme.headlineMedium,
                    );
                  },
                  error: (error, stacktrace) => const Text('Error!!'),
                  loading: () => const CircularProgressIndicator(),
                );

                // return Text(
                //   "$counter",
                //   style: Theme.of(context).textTheme.headlineMedium,
                // );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {}, //counter.increment,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

final counterProvider = ChangeNotifierProvider<Counter>((ref) => Counter());

class Counter with ChangeNotifier {
  int counter = 1;
  increment() {
    counter++;
    notifyListeners();
  }
}

//이것을 api라고 가장을해보자
final futureProvider = FutureProvider<int>((ref) async {
  final future = Future.value(
    Future.delayed(const Duration(seconds: 3), () {
      // return Random().nextInt(5000);
      return Random().nextInt(5000);
    }),
  );

  try {
    final data = await future;
    return data;
  } catch (e) {
    rethrow;
  }
});

final streamProvider = StreamProvider<int>((ref) {
  final stream = Stream.periodic(const Duration(seconds: 1), (value) => value);
  return stream;
});
