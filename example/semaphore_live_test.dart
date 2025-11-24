import 'dart:io';
import 'package:schedulersms/schedulersms.dart';

/// Live Testing Script for Semaphore SMS Integration
///
/// **⚠️ SECURITY WARNING ⚠️**
/// This script contains a hardcoded API key for TESTING PURPOSES ONLY.
/// This is intentional per the project requirements to enable quick testing,
/// but should NEVER be used as a pattern in production code.
///
/// For production applications:
/// - ALWAYS use environment variables or secure secret management
/// - NEVER commit API keys to version control
/// - Rotate keys regularly
///
/// **WARNING**: This script will connect to the real Semaphore API and
/// may consume SMS credits when sending test messages.
///
/// Usage:
///   dart run example/semaphore_live_test.dart                    # Check balance only
///   dart run example/semaphore_live_test.dart 09171234567        # Send test SMS
///
/// API Key Configuration:
///   - By default, uses the test API key hardcoded below for convenience
///   - Override with environment variable: SEMAPHORE_API_KEY=your-key
///   - Example: SEMAPHORE_API_KEY=abc123 dart run example/semaphore_live_test.dart

void main(List<String> args) async {
  print('='.repeat(70));
  print('Semaphore SMS Live Test');
  print('='.repeat(70));
  print('');

  // Get API key from environment or use default test key
  // ⚠️ UNSAFE FOR PRODUCTION: Default key is included for testing convenience
  // This pattern should NOT be used in production or committed to public repos
  final apiKey = Platform.environment['SEMAPHORE_API_KEY'] ??
      '1fd72138299086e8fc5656a9826ac7e9';

  if (apiKey == '1fd72138299086e8fc5656a9826ac7e9') {
    print('⚠️  Using default test API key (TESTING ONLY)');
    print('   This is for demonstration purposes.');
    print('   To use your own key, set: SEMAPHORE_API_KEY=your-key');
    print('');
  } else {
    print('✓ Using API key from SEMAPHORE_API_KEY environment variable');
    print('');
  }

  // Initialize test helper
  print('Initializing Semaphore test helper...');
  final helper = SemaphoreTestHelper(apiKey: apiKey);

  try {
    await helper.initialize();
    print('✓ Successfully connected to Semaphore API');
    print('');

    // Get and display account information
    print('-'.repeat(70));
    print('Account Information');
    print('-'.repeat(70));

    final account = await helper.getAccountInfo();
    print('Account Name:    ${account.accountName}');
    print('Account ID:      ${account.accountId}');
    print('Status:          ${account.status}');
    print('Credit Balance:  ${account.creditBalance} credits');
    print('');

    // Check if user wants to send a test SMS
    if (args.isNotEmpty) {
      final phoneNumber = args[0];
      print('-'.repeat(70));
      print('Sending Test SMS');
      print('-'.repeat(70));
      print('Recipient:       $phoneNumber');
      print('Message:         "Test message from SchedulerSMS"');
      print('');
      print('⚠️  This will consume 1 SMS credit from your account.');
      print('');

      // Confirm before sending
      stdout.write('Continue? (yes/no): ');
      final confirmation = stdin.readLineSync()?.toLowerCase() ?? 'no';

      if (confirmation == 'yes' || confirmation == 'y') {
        print('');
        print('Sending SMS...');

        final result = await helper.sendTestSms(
          phoneNumber: phoneNumber,
          message: 'Test message from SchedulerSMS',
        );

        print('✓ SMS sent successfully!');
        print('');
        print('Message ID:      ${result.messageId}');
        print('Status:          ${result.status}');
        print('Network:         ${result.network}');
        print('Created At:      ${result.createdAt}');
        print('');
        print('Check the recipient phone to verify delivery.');
      } else {
        print('');
        print('SMS send cancelled.');
      }
    } else {
      print('-'.repeat(70));
      print('How to Send a Test SMS');
      print('-'.repeat(70));
      print('Run this script with a phone number argument:');
      print('  dart run example/semaphore_live_test.dart 09171234567');
      print('');
      print('This will send a test message to verify end-to-end delivery.');
    }

    print('');
    print('='.repeat(70));
    print('Test completed successfully!');
    print('='.repeat(70));
  } catch (e, stackTrace) {
    print('');
    print('❌ Error during testing:');
    print(e);
    print('');
    print('Stack trace:');
    print(stackTrace);
    exit(1);
  } finally {
    helper.dispose();
  }
}

extension _StringRepeat on String {
  String repeat(int times) => List.filled(times, this).join();
}
