#include <Servo.h>
#include <LiquidCrystal.h>

//crear un objeto LiquidCrystal (rs,enable,d4,d5,d6,d7)
LiquidCrystal lcd(7,6,5,4,3,2);

//Crear objeto tipo Servo 
Servo myservo;
int pos =0;

//Ultrasónico el sensor HC-SR04 
long duracion; //tiempo en que la onda viaja al objeto y regresa 
long distancia; //distancia del objeto 
int led = 13;
int trig=9; // recibe un pulso para comenzar el ciclo de medición
int echo=8; //devuelve un pulso continuo que dura el tiempo en que la onda tarda en ir y regresar del objeto

void setup() {
  //servo 
  myservo.attach(10); //pin 10 del arduino 
  
  //pantalla
  lcd.begin(16,2); //16 columnas y 2 filas 
  lcd.setCursor(1,0); //1ra columna y fila 0 
  lcd.print("LDR OUT= ");
  lcd.setCursor(1,1);
  lcd.print("Laboratorio");
  
  Serial.begin(9600);
  //ultrasonico
  pinMode(trig, OUTPUT); //emisor 
  pinMode(echo, INPUT); //receptor
  pinMode(led, OUTPUT); 
  
}

void loop() {
  //disparo para activar el ultrasónico
  digitalWrite(trig,LOW);
  delayMicroseconds(4); 
  digitalWrite(trig,HIGH);
  delayMicroseconds(10); 
  digitalWrite(trig,LOW);
  //termina el disparo de activación 

  duracion = pulseIn(echo,HIGH); //tiempo en que va y regresa la onda ultrasónica
  //calculo de la distancia 
  distancia = duracion /58.4; //distancia en cm 

  Serial.print("distancia: ");
  Serial.print(distancia);
  Serial.print("cm");
  Serial.println("");
  delay(100);

  if(distancia <=250){
    digitalWrite(led, HIGH);
    delay(30);    
  }else {
    digitalWrite(led, LOW);
  }
  
  //***************** pantalla LCD *****************
  int ldr = analogRead(A0);
  lcd.setCursor(10,0); //para escribir el valor del ldr 
  lcd.print(ldr);

  //********************** SERVO ***************
  for(pos =0; pos<=180; pos++) {
    myservo.write(pos);
    delay(20);
  }

  for(pos=180; pos >=0; pos --){
    myservo.write(pos);
    delay(20);
  }



    
}
