import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

extension OptionalInfixAddition<T extends num> on T? {
  T? operator +(T? other) {
    final current = this;

    if (current != null) {
      return current + (other ?? 0) as T;
    }

    if (other != null) {
      return other + (current ?? 0) as T;
    }

    return null;
  }
}

class Counter extends StateNotifier<int?> {
  Counter() : super(null);

  void increment() => state = state == null ? 1 : state + 1;
}

final counterProvider = StateNotifierProvider<Counter, int?>(
  (ref) => Counter(),
);

class HomePage extends ConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Counter App'),
      ),
      body: Column(
        children: [
          Consumer(
            builder: (context, ref, child) {
              final count = ref.watch(counterProvider);
              return Text(
                (count == null ? '0' : count.toString()),
                style: Theme.of(context).textTheme.titleMedium,
              );
            },
          ),
          TextButton(
            onPressed: ref.read(counterProvider.notifier).increment,
            child: const Text('Increase count'),
          ),
        ],
      ),
    );
  }
}
