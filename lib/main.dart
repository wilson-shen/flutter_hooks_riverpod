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

enum CITY {
  kl('Kuala Lumpur'),
  paris('Paris'),
  tokyo('Tokyo');

  const CITY(this.value);
  final String value;
}

Future<String> getWeather(CITY city) {
  return Future.delayed(
    const Duration(seconds: 1),
    () => {
      CITY.kl: '🌧️',
      CITY.paris: '🌤️',
      CITY.tokyo: '🌨️',
    }[city]!,
  );
}

final currentCityProvider = StateProvider<CITY?>(
  (ref) => null,
);

final weatherProvider = FutureProvider<String>((ref) {
  final city = ref.watch(currentCityProvider);

  if (city == null) {
    return '❓';
  }

  return getWeather(city);
});

class HomePage extends ConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentWeather = ref.watch(weatherProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather'),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 80.0,
            width: double.infinity,
            child: Center(
              child: currentWeather.when(
                data: (data) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    data,
                    style: const TextStyle(fontSize: 50),
                  ),
                ),
                error: (_, __) => const Text("Error 🚫"),
                loading: () => const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: CITY.values.length,
              itemBuilder: (context, index) {
                final city = CITY.values[index];
                final isSelected = city == ref.watch(currentCityProvider);

                return ListTile(
                  title: Text(
                    city.value,
                  ),
                  trailing: isSelected ? const Icon(Icons.check) : null,
                  onTap: () {
                    ref.read(currentCityProvider.notifier).state = city;
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
