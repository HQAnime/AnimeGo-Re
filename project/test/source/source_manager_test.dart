import 'package:animego/core/source/SourceManager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'fake_source.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('registers the built in source and defaults to it', () async {
    final manager = SourceManager();
    await manager.init();

    expect(manager.sources.map((source) => source.id), contains('hianime'));
    expect(manager.active.id, 'hianime');
  });

  test('selecting a source updates the active source and notifier', () async {
    final manager = SourceManager();
    await manager.init();
    manager.register(FakeSource());

    await manager.select('fake');

    expect(manager.active.id, 'fake');
    expect(SourceManager.activeNotifier.value, 'fake');
  });

  test('selecting an unknown source is ignored', () async {
    final manager = SourceManager();
    await manager.init();

    await manager.select('does-not-exist');

    expect(manager.active.id, 'hianime');
  });
}
