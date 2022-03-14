/*
Copyright 2020 Adobe. All rights reserved.
This file is licensed to you under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License. You may obtain a copy
of the License at http://www.apache.org/licenses/LICENSE-2.0
Unless required by applicable law or agreed to in writing, software distributed under
the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR REPRESENTATIONS
OF ANY KIND, either express or implied. See the License for the specific language
governing permissions and limitations under the License.
*/

import 'package:flutter/services.dart';
import 'package:flutter_aepcore/flutter_aepcore.dart';
import 'package:flutter_aepcore/src/aepextension_event.dart';
import 'package:flutter_aepcore/src/aepmobile_logging_level.dart';
import 'package:flutter_aepcore/src/aepmobile_privacy_status.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const MethodChannel channel = MethodChannel('flutter_aepcore');

  TestWidgetsFlutterBinding.ensureInitialized();

  group('extensionVersion', () {
    final String testVersion = "2.5.0";
    final List<MethodCall> log = <MethodCall>[];

    setUp(() {
      channel.setMockMethodCallHandler((MethodCall methodCall) async {
        log.add(methodCall);
        return testVersion;
      });
    });

    test('invokes correct method', () async {
      await MobileCore.extensionVersion;

      expect(log, <Matcher>[
        isMethodCall(
          'extensionVersion',
          arguments: null,
        ),
      ]);
    });

    test('returns correct result', () async {
      expect(await MobileCore.extensionVersion, testVersion);
    });
  });

  group('trackAction', () {
    final String testAction = "myTestAction";
    final Map<String, String> testContextData = {
      "context1Key": "context1Value"
    };
    final List<MethodCall> log = <MethodCall>[];

    setUp(() {
      channel.setMockMethodCallHandler((MethodCall methodCall) async {
        log.add(methodCall);
        return null;
      });
    });

    test('invokes correct method', () async {
      await MobileCore.trackAction(testAction, data: testContextData);

      expect(log, <Matcher>[
        isMethodCall(
          'track',
          arguments: {
            "type": "action",
            "name": testAction,
            "data": testContextData
          },
        ),
      ]);
    });
  });

  group('trackState', () {
    final String testState = "myTestState";
    final Map<String, String> testContextData = {
      "context1Key": "context1Value"
    };
    final List<MethodCall> log = <MethodCall>[];

    setUp(() {
      channel.setMockMethodCallHandler((MethodCall methodCall) async {
        log.add(methodCall);
        return null;
      });
    });

    test('invokes correct method', () async {
      await MobileCore.trackState(testState, data: testContextData);

      expect(log, <Matcher>[
        isMethodCall(
          'track',
          arguments: {
            "type": "state",
            "name": testState,
            "data": testContextData
          },
        ),
      ]);
    });
  });

  group('setAdvertisingIdentifier', () {
    final String testAdId = "test-aid";
    final List<MethodCall> log = <MethodCall>[];

    setUp(() {
      channel.setMockMethodCallHandler((MethodCall methodCall) async {
        log.add(methodCall);
        return null;
      });
    });

    test('invokes correct method', () async {
      await MobileCore.setAdvertisingIdentifier(testAdId);

      expect(log, <Matcher>[
        isMethodCall(
          'setAdvertisingIdentifier',
          arguments: testAdId,
        ),
      ]);
    });
  });

  group('dispatchEvent', () {
    final Map<dynamic, dynamic> eventConstructorData = {
      "eventName": "testresponseEvent",
      "eventType": "testresponseEvent",
      "eventSource": "testEventSource",
      "eventData": {"eventDataKey": "eventDataValue"}
    };
    final Event expectedEvent = Event(eventConstructorData);
    final List<MethodCall> log = <MethodCall>[];

    setUp(() {
      channel.setMockMethodCallHandler((MethodCall methodCall) async {
        log.add(methodCall);
        return true;
      });
    });

    test('invokes correct method', () async {
      await MobileCore.dispatchEvent(expectedEvent);

      expect(log, <Matcher>[
        isMethodCall(
          'dispatchEvent',
          arguments: eventConstructorData,
        ),
      ]);
    });

    test('returns correct result', () async {
      expect(await MobileCore.dispatchEvent(expectedEvent), true);
    });
  });

  group('dispatchEventWithResponseCallback', () {
    final Map<dynamic, dynamic> eventConstructorData = {
      "eventName": "testresponseEvent",
      "eventType": "testresponseEvent",
      "eventSource": "testEventSource",
      "eventData": {"eventDataKey": "eventDataValue"}
    };
    final Event expectedEvent = Event(eventConstructorData);
    final Event returnedEvent = Event({
      "eventName": "testrequestEvent",
      "eventType": "testrequestEvent",
      "eventSource": "testEventSource",
      "eventData": {"eventDataKey": "eventDataValue"}
    });

    final List<MethodCall> log = <MethodCall>[];

    setUp(() {
      channel.setMockMethodCallHandler((MethodCall methodCall) async {
        log.add(methodCall);
        return returnedEvent.data;
      });
    });

    test('invokes correct method', () async {
      await MobileCore.dispatchEventWithResponseCallback(expectedEvent);

      expect(log, <Matcher>[
        isMethodCall(
          'dispatchEventWithResponseCallback',
          arguments: eventConstructorData,
        ),
      ]);
    });

    test('returns correct result', () async {
      final actualEvent =
          await MobileCore.dispatchEventWithResponseCallback(expectedEvent);
      expect(actualEvent.eventName, returnedEvent.eventName);
    });
  });

  group('AEPEvent', () {
    final String eventName = "testEventName";
    final String eventType = "testEventType";
    final String eventSource = "testEventSource";
    final Map<dynamic, dynamic> eventData = {"testEventKey": "testEventValue"};
    final Map<dynamic, dynamic> eventConstructorData = {
      "eventName": eventName,
      "eventType": eventType,
      "eventSource": eventSource,
      "eventData": eventData
    };

    final Event event =
        Event.createEvent(eventName, eventType, eventSource, eventData);

    test('returns correct result', () async {
      expect(event.eventName, eventName);
      expect(event.eventType, eventType);
      expect(event.eventSource, eventSource);
      expect(event.eventData, eventData);
      expect(event.data, eventConstructorData);
    });
  });

  group('getSdkIdentities', () {
    final String testSdkIdentities = "sdkIdentities";
    final List<MethodCall> log = <MethodCall>[];

    setUp(() {
      channel.setMockMethodCallHandler((MethodCall methodCall) async {
        log.add(methodCall);
        return testSdkIdentities;
      });
    });

    test('invokes correct method', () async {
      await MobileCore.sdkIdentities;

      expect(log, <Matcher>[
        isMethodCall(
          'getSdkIdentities',
          arguments: null,
        ),
      ]);
    });

    test('returns correct result', () async {
      String? sdkIdentitiesResult = await MobileCore.sdkIdentities;
      expect(sdkIdentitiesResult, testSdkIdentities);
    });
  });

  group('getPrivacyStatus', () {
    final List<MethodCall> log = <MethodCall>[];

    setUp(() {
      channel.setMockMethodCallHandler((MethodCall methodCall) async {
        log.add(methodCall);
        return PrivacyStatus.opt_in.value;
      });
    });

    test('invokes correct method', () async {
      await MobileCore.privacyStatus;

      expect(log, <Matcher>[
        isMethodCall(
          'getPrivacyStatus',
          arguments: null,
        ),
      ]);
    });

    test('returns correct result', () async {
      PrivacyStatus privacyStatus = await MobileCore.privacyStatus;
      expect(privacyStatus.value, PrivacyStatus.opt_in.value);
    });
  });

  group('setLogLevel', () {
    final LogLevel logLevel = LogLevel.error;
    final List<MethodCall> log = <MethodCall>[];

    setUp(() {
      channel.setMockMethodCallHandler((MethodCall methodCall) async {
        log.add(methodCall);
        return null;
      });
    });

    test('invokes correct method', () async {
      await MobileCore.setLogLevel(logLevel);

      expect(log, <Matcher>[
        isMethodCall(
          'setLogLevel',
          arguments: logLevel.value,
        ),
      ]);
    });
  });

  group('setPrivacyStatus', () {
    final PrivacyStatus privacyStatus = PrivacyStatus.opt_in;
    final List<MethodCall> log = <MethodCall>[];

    setUp(() {
      channel.setMockMethodCallHandler((MethodCall methodCall) async {
        log.add(methodCall);
        return null;
      });
    });

    test('invokes correct method', () async {
      await MobileCore.setPrivacyStatus(privacyStatus);

      expect(log, <Matcher>[
        isMethodCall(
          'setPrivacyStatus',
          arguments: privacyStatus.value,
        ),
      ]);
    });
  });

  group('updateConfiguration', () {
    final Map<String, String> testConfig = {"configKey": "configValue"};
    final List<MethodCall> log = <MethodCall>[];

    setUp(() {
      channel.setMockMethodCallHandler((MethodCall methodCall) async {
        log.add(methodCall);
        return null;
      });
    });

    test('invokes correct method', () async {
      await MobileCore.updateConfiguration(testConfig);

      expect(log, <Matcher>[
        isMethodCall(
          'updateConfiguration',
          arguments: testConfig,
        ),
      ]);
    });
  });

  group('clearUpdatedConfiguration', () {
    final List<MethodCall> log = <MethodCall>[];

    setUp(() {
      channel.setMockMethodCallHandler((MethodCall methodCall) async {
        log.add(methodCall);
        return null;
      });
    });

    test('invokes correct method', () async {
      await MobileCore.clearUpdatedConfiguration();

      expect(log, <Matcher>[
        isMethodCall('clearUpdatedConfiguration', arguments: null),
      ]);
    });
  });

  group('collectPii', () {
    final Map<String, String> testPiiData = {"testKey": "testValue"};
    final List<MethodCall> log = <MethodCall>[];

    setUp(() {
      channel.setMockMethodCallHandler((MethodCall methodCall) async {
        log.add(methodCall);
        return null;
      });
    });

    test('invokes correct method', () async {
      await MobileCore.collectPii(testPiiData);

      expect(log, <Matcher>[
        isMethodCall(
          'collectPii',
          arguments: testPiiData,
        ),
      ]);
    });
  });

  group('setAppGroup', () {
    final String testAppGroup = "testAppGroup";
    final List<MethodCall> log = <MethodCall>[];

    setUp(() {
      channel.setMockMethodCallHandler((MethodCall methodCall) async {
        log.add(methodCall);
        return null;
      });
    });

    test('invokes correct method', () async {
      await MobileCore.setAppGroup(testAppGroup);

      expect(log, <Matcher>[
        isMethodCall(
          'setAppGroup',
          arguments: testAppGroup,
        ),
      ]);
    });
  });
}
