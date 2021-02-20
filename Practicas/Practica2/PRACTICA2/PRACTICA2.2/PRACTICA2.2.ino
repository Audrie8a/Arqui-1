#include <LiquidCrystal.h>
#include <Key.h>                //borrar si causa algunos problemas en compilación         
#include <Keypad.h>
#include <Servo.h>  //libreria del servomotor

Servo m1; //servomotor
Servo m2;

int pin = 1; //pin para mover el motor
int grados = 0; // variable que simula los grados
int t = 50; //delay 100ms simulan 5s aprox
bool primeraPasada=false;

int pin111 = 14; //pin para mover el motor
int grados2 = 0; // variable que simula los grados
int t2 = 50; //delay 100ms simulan 5s aprox
bool segundaPasada=false;

const int VELOCIDAD_TEXTO = 150;//variable para texto
unsigned long TiempoAlarma = 20000;//variable para alarma
bool mensajeinicial=true;
bool sensorultrasonico=true;
bool contra=false;
bool activacionAlarma=false;
//Declaración de variables del sensor
long tiempo=0; //Donde se va a guardar el tiempo de duración del pulso generado por el pin Echo
long distancia=0; //Donde se va a guardar la distancia calculada
int pinTrigger=A10; 
int pinEcho=A11; 
int pinTriggerS=A13; 
int pinEchoS=A14; 
int a=0, b=0, c=0, d=0, e=0, g=0;//acumuladores de datos enteros para la contrseña.
int var=0; //incremento apara el switch.
int C1=2, C2=0, C3=2, C4=1, C5=0, C6=4;//contraseña....Ustedes pueden codificarlo la contraseña
char f='*';  //caracter para cubrir la contraseña.
int veces=0,incorrecto=0; //seguridad de solo 3 intentos para ingresar la contraseña correcta.
int aviso=3; //aviso para mostrar los intentos como seguridad para el usuario.
const byte filas = 4; //cuatro  filas.
const byte columnas = 4; //cuatro columnas.
char tecla[filas][columnas] = {
  {'7','8','9','A'},
  {'4','5','6','B'},
  {'1','2','3','C'},
  {'*','0','#','D'}
};

byte pinFilas[filas] = {7, 6, 5, 4}; //conectarse a las patillas de salida de fila del teclado.
byte pinColumnas[columnas] = {3, 2, A4, A5}; //conectarse a las patillas de las columnas del teclado.

Keypad keypad = Keypad( makeKeymap(tecla), pinFilas, pinColumnas, filas, columnas );
LiquidCrystal lcd(13,12,11,10,9,8); //RS,E,D4,D5,D6,D7

//CONTROL DE ILUMINACION---------------------------------------------------------------------------------------------------------------------
bool CCLight=false;
bool PassRight=false;
//Habitaciones: Estado Inicial - Estados Actual 
int Hi1=0; int Ha1=0;
int Hi2=0; int Ha2=0;
int Hi3=0; int Ha3=0;
int Hi4=0; int Ha4=0;

int ldr=0;
void RecorrerHabitaciones(){
  for (int i=1; i<=4;i++){
    if (i==1){    //Habitacion 1
      ldr=analogRead(A0);
      Ha1=ldr;
      lcd.setCursor(1,0); 
      lcd.print("Habitacion 1:  ");
      if(ldr<=105){      
        lcd.setCursor(1,1);
        lcd.print("Luz Apagada");
        delay(2000);
      }else{              
        lcd.setCursor(1,1);
        lcd.print("Luz Encendida");
        delay(2000);
      }     
    }else if (i==2){
      ldr=analogRead(A1);
      Ha2=ldr;
      lcd.setCursor(1,0); 
      lcd.print("Habitacion 2:  ");
      if(ldr<=105){      
        lcd.setCursor(1,1);
        lcd.print("Luz Apagada");
        delay(2000);
      }else{              
        lcd.setCursor(1,1);
        lcd.print("Luz Encendida");
        delay(2000);
      }     
    }else if (i==3){
      ldr=analogRead(A2);
      Ha3=ldr;
      lcd.setCursor(1,0); 
      lcd.print("Habitacion 3:  ");
      if(ldr<=105){      
        lcd.setCursor(1,1);
        lcd.print("Luz Apagada");
        delay(3000);
      }else{              
        lcd.setCursor(1,1);
        lcd.print("Luz Encendida");
        delay(2000);
      }  
    }else if (i==4){
      ldr=analogRead(A3);
      Ha4=ldr;
      lcd.setCursor(1,0); 
      lcd.print("Habitacion 4:  ");
      if(ldr<=105){      
        lcd.setCursor(1,1);
        lcd.print("Luz Apagada");
        delay(3000);
      }else{              
        lcd.setCursor(1,1);
        lcd.print("Luz Encendida");
        delay(3000);
      }  
    }
  } 
  
}


void CheckControlLight(){
  Hi1=Ha1; Ha1=analogRead(A0);
  Hi2=Ha2; Ha2=analogRead(A1);
  Hi3=Ha3; Ha3=analogRead(A2);
  Hi4=Ha4; Ha4=analogRead(A3);
  if((Hi1+Hi2+Hi3+Hi4)==0 && (Ha1+Ha2+Ha3+Ha4)==0){ //Estado Inicial
    RecorrerHabitaciones();      
  }else if(((Hi1-Ha1)+(Hi2-Ha2)+(Hi3-Ha3)+(Hi4-Ha4))==0){ //Ya hizo un recorrido y nada ha cambiado
    lcd.setCursor(1,0);
    lcd.print("Control Luces");
    lcd.setCursor(1,1);
    lcd.print("Finalizado   ");
    CCLight=true;
    delay(800);
  }else{  //Ya hizo un recorrido y hay cambios
    RecorrerHabitaciones();   
    CCLight=false;
  }
}

//--------------------------------------------------------------------------------------------------------------------------------------------
void reinicio(){
  a=0;
  b=0;
  c=0;
  d=0;
  e=0;
  g=0;
  veces=0;
  incorrecto=0;
  aviso=3;
  var=0;
}

void mensajeInicio(){
    mostrarMensaje("CASA INTELIGENTE ACE1");
    delay(VELOCIDAD_TEXTO);
    lcd.clear();
    mostrarMensaje("ACE1-B-G4-S1");
  
}
String mostrarMensaje (String texto){
 const int tamano_texto = texto.length();
 for(int i=16;i>=1;i--)    //ciclo para mostrar el texto por toda la pantalla dezplanzando 
 {
   lcd.clear();
   lcd.setCursor(i, 1); //coordenada de posicion
   lcd.print(texto); // el texto
   delay(VELOCIDAD_TEXTO);// la espera
 }
 for(int i=1; i<=tamano_texto ; i++) 
 {
   String mensaje = texto.substring(i-1);//devuelve el texto
   lcd.setCursor(0, 1);
   lcd.print(mensaje);
   delay(VELOCIDAD_TEXTO);
   lcd.clear();
 }
 return texto;
}
void sensorUltrasonico(){
    digitalWrite(pinTrigger,LOW); //Se asegura un cero en el pin que se va a utilizar como Trigger
    delayMicroseconds(5);//Restardo de 5 microsegundo
    digitalWrite(pinTrigger,HIGH); //Se establece en alto el pin del trigger para comenzar el pulso de inicio del sensor
    delayMicroseconds(10); //retardo de 10 microsegundos (tiempo minimo para inicializar el trigger del sensor)
    digitalWrite(pinTrigger,LOW);//Se establece en bajo el pin del Trigger para terminar el pulso de inicio del sensor
    tiempo=pulseIn(pinEcho,HIGH);//Se inicia la función pulseIn para que mida el tiempo del pulso generado por el Echo del sensor
    distancia=tiempo*0.0343/2; //Calculo de distancia a la cual se encuentra el objeto
    //Impresión en el LCD
    if (distancia < 150) {

     lcd.clear();
     mensajeinicial=false;
     sensorultrasonico=false;
     contra=true;
     password();
    }else {
      sensorultrasonico=true;
      mensajeinicial=true;
      lcd.clear();

    }

//delay(50);
}
void sensorUltrasonicoSalida(){
    digitalWrite(pinTriggerS,LOW); //Se asegura un cero en el pin que se va a utilizar como Trigger
    delayMicroseconds(5);//Restardo de 5 microsegundo
    digitalWrite(pinTriggerS,HIGH); //Se establece en alto el pin del trigger para comenzar el pulso de inicio del sensor
    delayMicroseconds(10); //retardo de 10 microsegundos (tiempo minimo para inicializar el trigger del sensor)
    digitalWrite(pinTriggerS,LOW);//Se establece en bajo el pin del Trigger para terminar el pulso de inicio del sensor
    tiempo=pulseIn(pinEchoS,HIGH);//Se inicia la función pulseIn para que mida el tiempo del pulso generado por el Echo del sensor
    distancia=tiempo*0.0343/2; //Calculo de distancia a la cual se encuentra el objeto
    //Impresión en el LCD
    if (distancia < 150) {
      segundaPasada=true;
      primeraPasada=false;
      PassRight=false;
     //mov2();
     //mov1();
     lcd.clear();
     //lcd.setCursor(3, 0); //coordenada de posicion
     //lcd.print("SALIDA");
     //codigode motor de salida
    }else {
  //    sensorultrasonico=true;
  //    mensajeinicial=true;
  //    lcd.clear();

    }

//delay(50);
}
void ActivarAlarma(){

     int tiempo = 0; 
     while(tiempo < TiempoAlarma){   
       pinMode(A8, OUTPUT);
       pinMode(A9, OUTPUT);
       digitalWrite(A8, HIGH); // valor alto,LED ON
       digitalWrite(A9, HIGH);
       lcd.setCursor(3, 0); //coordenada de posicion
       lcd.print("Acceso No");
       lcd.setCursor(3, 1); //coordenada de posicion
       lcd.print("Autorizado");
       delay(150); // espero
       digitalWrite(A8, LOW);
       digitalWrite(A9, LOW);//valor bajo, LED OFF
       delay(150); // espero    
       tiempo = tiempo + 300;
    }
}
void password(){
  char key = keypad.getKey();
  if (key){
    
     lcd.setCursor(5+var,1);
     lcd.print(key),lcd.setCursor(5+var,1),lcd.print(f);//imprimimos el caracter en el lcd
     key=key-48; //COVERCIÓN DE CHAR A ENTEROS -48 SEGUN EL CÓDIGO ASCII.
     var++; //var se incrementa para los case1,case2,case3,case4.
     switch(var){
        case 1:
          a=key; //almacenamos primer dígito para la contraseña que seria el 1
        break;
        case 2:
          b=key; //almacenamos segundo dígito para la contraseña que seria el 2
        break;
        case 3:
          c=key; //almacenamos tercer dígito para la contraseña que seria el 3
        break;
        case 4:
          d=key; //almacenamos cuarto dígito para la contraseña que seria el 4
        break;
        case 5:
          e=key; //almacenamos cuarto dígito para la contraseña que seria el 4
        break;
        case 6:
          g=key; //almacenamos cuarto dígito para la contraseña que seria el 4
          delay(100);
          if(a==C1 && b==C2 && c==C3 && d==C4 && e==C5 && g==C6){
              lcd.clear();
              lcd.setCursor(3,0);
              lcd.print("BIENVENIDO A");
              lcd.setCursor(3,1);
              lcd.print("CASA ^_^");             
              PassRight=true;
              contra=false;
              //lcd.clear();
              //mov1();
              digitalWrite(A0,HIGH);
              //delay(700);
              digitalWrite(A0,LOW);
              //llamar metodo iluminacion
              
          }else{
              lcd.clear();
              lcd.setCursor(3,0);
              lcd.print("ERROR EN");
              lcd.setCursor(2,1);
              lcd.print("CONTRASEÑA");
              
              digitalWrite(A1,HIGH);
              delay(400);
              lcd.clear();
              digitalWrite(A1,LOW);
              //ontra=false;
          }
      //------Seguridad para la contraseña y sus restricciones-------------------//
      
          if(a==C1 && b==C2 && c==C3 && d==C4 && e==C5 && g==C6){
              veces=0;//si es correcto el password ,variable veces no se incremeta.
              aviso=3;//variable aviso se mantiene en 3
          }else{
              veces ++; //incrementamos los intentos incorrectos de password para el bloqueo.
              aviso --; //decremento de variable aviso ,de 3 hasta 0 según las veces de fallas al ingresar el password.
              lcd.setCursor(2,0);
              lcd.print("LE QUEDA: ");
              lcd.setCursor(13,0);
              lcd.print(aviso);
              lcd.setCursor(2,1);
              lcd.print("OPORTUNIDAD");
              if(aviso==0){
                  lcd.clear();
                  lcd.setCursor(5,0);
                  lcd.print("ALARMA");
                  lcd.setCursor(4,1);
                  lcd.print("ACTIVADO");
                  contra=false;
                  activacionAlarma=true;
                 // ActivarAlarma();
                 
              }
              delay(300);lcd.clear();
          }
               
          while(veces>=3){
             activacionAlarma=true;
             ActivarAlarma();
             contra=true;
             activacionAlarma=false;
             reinicio();
          }//while es Bucle infinito de seguridad para bloquear los re intentos del password
      
          var=0;
          lcd.clear();    
        break;//se  termina el
      }
  }
  if(!key ){lcd.setCursor(0,0),lcd.print("INGRESE SU PASS");}//portada de inicio en el LCD
  delay(2);
}
//metodos del motor
 void mov1(){ //se mueve de 0 a 90 grados
  for (grados = 0; grados <= 90; grados++) {
    m1.write(grados);              
    delay(t);                      
  }  
}
void mov2(){ //se mueve de 90 a 0 grados
  for (grados = 90; grados >= 0; grados--) { 
    m1.write(grados);             
    delay(t);
  }
}
 void mov3(){ //se mueve de 0 a 90 grados
  for (grados2 = 0; grados2 <= 90; grados2++) {
    m2.write(grados2);              
    delay(t2);                      
  }  
}
void mov4(){ //se mueve de 90 a 0 grados
  for (grados2 = 90; grados2 >= 0; grados2--) { 
    m2.write(grados2);             
    delay(t2);
  }
}


void setup(){
  lcd.begin(16,2); //LCD (16 COLUMNAS Y 2 FILAS)
  
//  pinMode(A0,OUTPUT); //TRUE PASSWORD CORRECTO LED YELLOW.
  //pinMode(A1,OUTPUT); //FALSE PASSWORD INCORRECTO LED RED.
  pinMode(pinEcho,INPUT); // Configuración del pin 6 como entrada
  pinMode(pinTrigger,OUTPUT); //Configuración del pin 7 como salida
   pinMode(pinEchoS,INPUT); // Configuración del pin 6 como entrada
  pinMode(pinTriggerS,OUTPUT); //Configuración del pin 7 como salida
  m1.attach(pin);// asigna el pin
  m2.attach(pin111);// asigna el pin
}
 
void loop(){
  sensorUltrasonicoSalida();
  if(mensajeinicial==true){
    mensajeInicio();
  }
  if(sensorultrasonico==true){
    sensorUltrasonico();
  }
  if(contra==true && activacionAlarma==false){
    password();
  }
  if(primeraPasada==false && PassRight==true){
    mov2();   
    delay(300);
    mov1();
    delay(80);
    primeraPasada=true;
  }
  if(PassRight==true){   
    CheckControlLight();
  }

  if(segundaPasada==true){
    mov4();
    delay(300);
    mov3();
    delay(80);
    segundaPasada=false;
    mensajeinicial=true;
    sensorUltrasonico();    
    segundaPasada=false;
    Hi1=0; Hi2=0; Hi3=0; Hi4=0;
    Ha1=0; Ha2=0; Ha3=0; Ha4=0;
  }  

  
  if(activacionAlarma==true){
    ActivarAlarma();
  }


 }

 
