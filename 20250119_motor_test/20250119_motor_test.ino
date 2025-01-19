// Motor Connections
#define RPWM1 5   // Right motor PWM pin
#define LPWM1 6   // Left motor PWM pin
#define RPWM2 9  // Right motor 2 PWM pin
#define LPWM2 10   // Left motor 2 PWM pin

void setup() {
  // Set motor connections as outputs
  pinMode(RPWM1, OUTPUT);
  pinMode(LPWM1, OUTPUT);
  pinMode(RPWM2, OUTPUT);
  pinMode(LPWM2, OUTPUT);

  // Stop motors
  analogWrite(RPWM1, 0);
  analogWrite(LPWM1, 0);
  analogWrite(RPWM2, 0);
  analogWrite(LPWM2, 0);
}

void loop() {
  // Accelerate forward
  digitalWrite(RPWM1, LOW);
  digitalWrite(RPWM2, LOW);
  for (int i = 0; i < 255; i++) {
    analogWrite(LPWM1, i);
    analogWrite(LPWM2, i);
    delay(20);
  }

  delay(1000);

  // Decelerate forward
  for (int i = 255; i >= 0; i--) {
    analogWrite(LPWM1, i);
    analogWrite(LPWM2, i);
    delay(20);
  }

  delay(500);

  // Accelerate reverse
  digitalWrite(LPWM1, LOW);
  digitalWrite(LPWM2, LOW);
  for (int i = 0; i < 255; i++) {
    analogWrite(RPWM1, i);
    analogWrite(RPWM2, i);
    delay(20);
  }

  delay(1000);

  // Decelerate reverse
  for (int i = 255; i >= 0; i--) {
    analogWrite(RPWM1, i);
    analogWrite(RPWM2, i);
    delay(20);
  }

  delay(500);
}
