/// Base class for managing RxDart stream subscriptions
///
/// This class provides a convenient way to track and dispose of
/// multiple stream subscriptions at once.
library;

import 'dart:async';

/// Base class for objects that manage stream subscriptions
///
/// Classes that extend this can add subscriptions and unsubscribe from all
/// of them at once when the object is disposed.
class Subscribed {
  final List<StreamSubscription> _subscriptions = [];

  /// Add one or more subscriptions to be managed
  void addSubscriptions(List<StreamSubscription> subscriptions) {
    _subscriptions.addAll(subscriptions);
  }

  /// Add a single subscription to be managed
  void addSubscription(StreamSubscription subscription) {
    _subscriptions.add(subscription);
  }

  /// Unsubscribe from all managed subscriptions
  void unsubscribe() {
    for (final subscription in _subscriptions) {
      subscription.cancel();
    }
    _subscriptions.clear();
  }

  /// Dispose of this object and cancel all subscriptions
  void dispose() {
    unsubscribe();
  }
}
