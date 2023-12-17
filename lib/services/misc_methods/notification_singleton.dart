class NotificationCounter {
  static final NotificationCounter _singleton = NotificationCounter._internal();

  factory NotificationCounter() {
    return _singleton;
  }

  NotificationCounter._internal();

  int _notificationCount = 1;

  int get notificationCount => _notificationCount;

  set notificationCount(int value) {
    _notificationCount = value;
  }

  void increment() {
    _notificationCount++;
  }

  void reset() {
    _notificationCount = 1;
  }
}

// Example usage:
void main() {
  // Get the singleton instance
  NotificationCounter notificationCounter = NotificationCounter();

  // Access the notificationCount
  print(notificationCounter.notificationCount); // Output: 0

  // Increment the notificationCount
  notificationCounter.increment();
  print(notificationCounter.notificationCount); // Output: 1

  // Reset the notificationCount
  notificationCounter.reset();
  print(notificationCounter.notificationCount); // Output: 0
}
