import 'dart:io';

void main() async {
  const teamId = 'Rajat Bisht (Personal Team)'; // ✅ your team id
  const bundleId = 'com.jinx.vibe'; // change if needed

  final pbxprojPath = 'macos/Runner.xcodeproj/project.pbxproj';

  print('🚀 Starting FULL macOS fix...\n');

  // ===== STEP 1: Fix Xcode Signing =====
  final file = File(pbxprojPath);

  if (file.existsSync()) {
    print('🔧 Fixing signing + bundle id...');

    String content = await file.readAsString();

    content = content.replaceAllMapped(
      RegExp(r'PRODUCT_BUNDLE_IDENTIFIER = .*?;'),
      (_) => 'PRODUCT_BUNDLE_IDENTIFIER = $bundleId;',
    );

    content = content.replaceAll(
        'CODE_SIGN_STYLE = Manual;', 'CODE_SIGN_STYLE = Automatic;');

    content = content.replaceAll(
        'ProvisioningStyle = Manual;', 'ProvisioningStyle = Automatic;');

    if (content.contains('DEVELOPMENT_TEAM')) {
      content = content.replaceAllMapped(
        RegExp(r'DEVELOPMENT_TEAM = .*?;'),
        (_) => 'DEVELOPMENT_TEAM = $teamId;',
      );
    } else {
      content = content.replaceAll(
        'buildSettings = {',
        'buildSettings = {\n\t\t\t\tDEVELOPMENT_TEAM = $teamId;',
      );
    }

    await file.writeAsString(content);
    print('✅ Signing fixed\n');
  } else {
    print('⚠️ Xcode project not found\n');
  }

  // ===== STEP 2: Clean EVERYTHING =====
  await run('flutter clean');
  await run('rm -rf build');
  await run('rm -rf macos/Pods');
  await run('rm -rf macos/Podfile.lock');
  await run('rm -rf ~/Library/Developer/Xcode/DerivedData');

  // ===== STEP 3: Get dependencies =====
  await run('flutter pub get');

  // ===== STEP 4: Install pods =====
  await run('cd macos && pod install');

  // ===== STEP 5: Run app =====
  await run('flutter run -d macos');

  print('\n🎉 ALL DONE! Your project should work now.');
}

Future<void> run(String cmd) async {
  print('▶️ $cmd');

  final process = await Process.start(
    'bash',
    ['-c', cmd],
    runInShell: true,
  );

  stdout.addStream(process.stdout);
  stderr.addStream(process.stderr);

  await process.exitCode;
}
