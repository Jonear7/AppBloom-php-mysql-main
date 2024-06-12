# bloom

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

-- Databse bloom

-- Create table for booking
CREATE TABLE IF NOT EXISTS booking (
  booking_ID INT(11) NOT NULL AUTO_INCREMENT,
  user_id INT(11),
  Room_ID INT(11),
  checkin_out VARCHAR(50),
  total_price DECIMAL(10,2),
  room_amount INT(11),
  PRIMARY KEY (booking_ID),
  INDEX User_ID (user_id),
  INDEX Room_ID (Room_ID),
  FOREIGN KEY (user_id) REFERENCES users (user_id),
  FOREIGN KEY (Room_ID) REFERENCES room (id)
);

-- Create table for payment
CREATE TABLE IF NOT EXISTS payment (
  pay_ID INT(11) NOT NULL AUTO_INCREMENT,
  pay_type VARCHAR(50),
  pay_date DATE,
  PRIMARY KEY (pay_ID)
);

-- Create table for room
CREATE TABLE IF NOT EXISTS room (
  id INT(11) NOT NULL AUTO_INCREMENT,
  name VARCHAR(50),
  image LONGBLOB NOT NULL,
  description TEXT,
  price DECIMAL(10,2),
  PRIMARY KEY (id)
);

-- Create table for users
CREATE TABLE IF NOT EXISTS users (
  user_id INT(11) NOT NULL AUTO_INCREMENT,
  username VARCHAR(50),
  password VARCHAR(255),
  email VARCHAR(50),
  phone VARCHAR(20),
  PRIMARY KEY (user_id)
);
