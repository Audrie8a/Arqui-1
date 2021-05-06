#include <SoftwareSerial.h>
#include "LedControlMS.h"
#include <Keypad.h>
#include <LiquidCrystal.h>
#include <MD_Parola.h>
#define HARDWARE_TYPE MD_MAX72XX::FC16_HW

//------------------------------------------------------------------------------------------CONDICIONES LOOP
int Inicio = 1; 
bool btnAceptar= false;
char caracter;
String actualizar; //Utilizado para recibir variables, para toma de decisiones
String text2;
String condicionText;
int estacionA=0; int estacionB=0; int estacionC=0;
int contadorLetra1=0; int contadorLetra2=0; int contadorEstaciones=1;
int suma1=0; int suma2=0;
//------------------------------------------------------------Contraseña

int a=0, b=0, c=0, d=0, e=0, g=0;//acumuladores de datos enteros para la contrseña.
int var=0; //incremento apara el switch.
int C1=1, C2=2, C3=3, C4=4, C5=5, C6=6;//contraseña....Ustedes pueden codificarlo la contraseña
char f='*';  //caracter para cubrir la contraseña.
int veces=0,incorrecto=0; //seguridad de solo 3 intentos para ingresar la contraseña correcta.
int aviso=3; //aviso para mostrar los intentos como seguridad para el usuario.
const byte filas2 = 4; //cuatro  filas.
const byte columnas2 = 4; //cuatro columnas.

byte pinFilas[filas2] = {25,26,27,28}; //conectarse a las patillas de salida de fila del teclado.
byte pinColumnas[columnas2] = {24,23,22,29}; //conectarse a las patillas de las columnas del teclado.

char tecla[filas2][columnas2] = {
  {'7','8','9','A'},
  {'4','5','6','B'},
  {'1','2','3','C'},
  {'*','0','#','D'}
};

Keypad keypad = Keypad( makeKeymap(tecla), pinFilas, pinColumnas, filas2, columnas2 );
//------------------------------------------------------------ LCD
LiquidCrystal lcd(46,47,48,49,50,51); //RS,E,D4,D5,D6,D7
//------------------------------------------------------------ ESTACIONES

String text="";

int estacion=0;
int actual=-1;
int columnas = 0;

int filas[]={0, 0, 0, 0, 0, 0, 0, 0};

int dibujo[8][8];

boolean hayTexto=false;


SoftwareSerial miBT(12, 9);

LedControl matrix = LedControl(11, 13, 10, 3);

void EstacionSetup(){
  pinMode(7, OUTPUT);
  Serial.begin(9600);
  miBT.begin(10500);
  matrix.shutdown(0, false);
  matrix.shutdown(1, false);
  matrix.shutdown(2, false);
  matrix.setIntensity(0, 8);
  matrix.setIntensity(1, 8);
  matrix.setIntensity(2, 8);
  matrix.clearDisplay(0);
  matrix.clearDisplay(1);
  matrix.clearDisplay(2);
}

void EstacionLoop(){ 
    
    if(text.length()==1){
      actual=text.toInt()-1;      
      if(actual!=-1){
        hayTexto=true;
        Serial.println(actual);
        text="";
        if(estacion==0){
          columnas=3;
          estacion=1;
        }else if(estacion==1){
          columnas=6;
          estacion=2;
        }else if(estacion==2){
          columnas=8;
          estacion=3;
        }
      }
    }else{     
      int numbers = 0;
      String textAux;
      for(int i=0; i<text.length(); i++){
        if(text[i]!='-'){
          textAux += text[i];
        }else{
          filas[numbers]=textAux.toInt();  
          numbers++;
          textAux="";
        }
      }
      text="";
  
      for(int i=0; i<8; i++){
        toBinary(filas[i], i);
      }     
    }
    
    if(hayTexto){  
        
        switch((actual+1)){
          case 1:
            estacionA=1;
            
            break;
          case 2:
            estacionB=1;
            break;
          case 3:
            estacionC=1;
            break;  
        }
        suma1=estacionA+estacionB+estacionC;
        digitalWrite(7, HIGH);        
        imprimirMatriz(actual, columnas);
        if(actual!=-1){
          lcd.clear();
          lcd.setCursor(0,0);
          lcd.print("Estacion ");
          lcd.setCursor(0,10);
          lcd.print(actual+1);
        }
        
        if(estacion==3){
          estacion=0;
          /*text="";
          hayTexto=false;
          estacion=0;
          columnas=0;
          //delay(5000);
          unsigned long tiempoBorrar = millis();
          unsigned long tiempoSegundosBorrar = tiempoBorrar/1000;
          if(tiempoSegundosBorrar==5  ){
            matrix.clearDisplay(0);
            matrix.clearDisplay(1);
            matrix.clearDisplay(2);
          }*/
          
        }  
    }
}
void LetreroEstaciones(int numEstacion, int conteo){
  bool EstacionA=false;
  bool EstacionB=false;
  bool EstacionC=false;
  if(numEstacion!=0){
    if(conteo==1){
      switch(numEstacion){
      case 1:
        LetreroSetupZone(2);
        LetreroSetupZone(3);
        EstacionA=true;
        break;
      case 2:
        LetreroSetupZone(1);
        LetreroSetupZone(3);
        EstacionB=true;
        break;
      case 3:
        LetreroSetupZone(2);
        LetreroSetupZone(1);
        EstacionC=true;
        break;
      }
    }
  }
}
void ReiniciarEstaciones(){
   text="";
   hayTexto=false;
   estacion=0;
   columnas=0;
   matrix.clearDisplay(0);
   matrix.clearDisplay(1);
   matrix.clearDisplay(2); 
   actual=-1;
}
unsigned long tiempoIni=0;
unsigned long tiempoSegundoss=0;
unsigned long tiempoActuals=0;

int imprimirTexto(int numMatriz, int contadr){
  String chars[8]={"A","C","Y","E","1"," ", "G","4"};
  String letr= chars[contadr];
  char CH=letr[0];
  tiempoActuals=millis();
  //tiempoSegundoss=(tiempoActuals/1000)-(tiempoIni/1000);
 // if(tiempoActuals>(tiempoIni+1000)){
    matrix.displayChar(numMatriz, matrix.getCharArrayPosition(CH));
    delay(200);
    tiempoIni=millis();
    contadr++;
    if(contadr==8){
      contadr=0;
    }
  //}
  return contadr;
}
void imprimirMatriz(int matriz, int columna){
  for(int i=0; i<8; i++){
      for(int j=0; j<columna; j++){
        if(dibujo[i][j]==1){
          matrix.setLed(matriz, i, j, HIGH);
        }
      }
  }
}

void toBinary(int numero, int fila){
  
  int num=numero;
  if(num>=128){
    num=num-128;
    dibujo[fila][7]=1;
  }else{
    dibujo[fila][7]=0;
  }

  if(num>=64){
    num=num-64;
    dibujo[fila][6]=1;
  }else{
    dibujo[fila][6]=0;
  }

  if(num>=32){
    num=num-32;
    dibujo[fila][5]=1;
  }else{
    dibujo[fila][5]=0;
  }

  if(num>=16){
    num=num-16;
    dibujo[fila][4]=1;
  }else{
    dibujo[fila][4]=0;
  }

  if(num>=8){
    num=num-8;
    dibujo[fila][3]=1;
  }else{
    dibujo[fila][3]=0;
  }

  if(num>=4){
    num=num-4;
    dibujo[fila][2]=1;
  }else{
    dibujo[fila][2]=0;
  }

  if(num>=2){
    num=num-2;
    dibujo[fila][1]=1;
  }else{
    dibujo[fila][1]=0;
  }

  if(num>=1){
    num=num-1;
    dibujo[fila][0]=1;
  }else{
    dibujo[fila][0]=0;
  }
}


//--------------------------------------------------------------------------------------------------------------Mensaje Estaciones apagadas: ACYE 1 G4

MD_Parola myDisplay = MD_Parola(HARDWARE_TYPE, 11, 13, 10, 3);
int velocidad=100;
int retardo=800;
int curText=0;

typedef struct
{
  uint8_t spacing;  // character spacing
  const char *msg;  // message to display
} msgDef_t;

msgDef_t  M[] =
{
  { 0, "   A"},  { 1, "A C" },  { 0, "C E" },  { 1, "E   " },  { 0, "  1" },
  { 1, "1   " },  { 0, "  G" },  { 1, "G 4" },  { 0, "4  " }
};

void MostrarMensaje(){
  /*int slide_scroll_speed = map(velocidad, 1023, 0, 400, 15);
  myDisplay.setSpeed(slide_scroll_speed);
  if (myDisplay.displayAnimate())
  {   
    myDisplay.displayReset();    
  }*/

  for (int j=0; j<9; j++){
    myDisplay.setTextBuffer(M[j].msg);
        myDisplay.print(M[j].msg);
        //myDisplay.displayReset();
        delay(800);          
  }
}

void LetreroSetup(){
  myDisplay.begin();
  myDisplay.displayClear();
  myDisplay.setIntensity(5);
  myDisplay.displayText("ACYE 1 G4", PA_LEFT, velocidad, 0, PA_SCROLL_RIGHT , PA_SCROLL_RIGHT );
}
void LetreroSetupZone(int zona){
  myDisplay.begin();
  myDisplay.displayClear();
  myDisplay.setIntensity(5);
  myDisplay.setZone(zona,0,7);
  myDisplay.displayText("ACYE 1 G4", PA_LEFT, velocidad, 0, PA_SCROLL_RIGHT , PA_SCROLL_RIGHT ); 
}
void LetreroLoop(){
  int slide_scroll_speed = map(velocidad, 1023, 0, 400, 15);
    myDisplay.setSpeed(slide_scroll_speed);
    if (myDisplay.displayAnimate()){   
      myDisplay.displayReset();    
    }
}



//--------------------------------------------------------------------------------------------------------------KEY PAD
void KeyPadSetup(){
  lcd.begin(16,2);
}

void KeyPadLoop(){
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
              lcd.print("Bienvenido");
              Inicio=2;
              digitalWrite(A0,HIGH);
              delay(700);
              lcd.clear();
              //digitalWrite(A0,LOW);
          }else{
              lcd.clear();
              lcd.setCursor(3,0);
              lcd.print("ERROR");
              digitalWrite(A1,HIGH);
              delay(400);
              lcd.clear();
              //digitalWrite(A1,LOW);
          }
     
      
          var=0;
          lcd.clear();    
        break;//se  termina el
      }
  }
  if(!key){lcd.setCursor(0,0),lcd.print("Ingrese Su PASS");}//portada de inicio en el LCD
  delay(2);
}

//---------------------------------------------------------------------------------------------------------MAIN
void setup() {
  // put your setup code here, to run once:
  
  KeyPadSetup();
  EstacionSetup();
  if(condicionText!="B"){
    LetreroSetup();
  }

  if(Inicio==0){
    LetreroSetupZone(4);
  }
}

void loop() {
  // put your main code here, to run repeatedly:

  //Aquí se reciben las isntrucciones de la aplicacion
  

  while(miBT.available()){
      delay(10);
      char c = miBT.read();
      text += c;
  }

  
  if(Inicio==1){
    KeyPadLoop();
    LetreroLoop();
      //MostrarMensaje();
    //EstacionLoop();
  } 
  if(Inicio==2){
    Inicio=0;
    ReiniciarEstaciones();
    //contadorLetra1=imprimirTexto(0,contadorLetra1);
    //LetreroLoop();
  }
  if (Inicio ==0){

    if(estacionA==1 || estacionB==1 || estacionC==1){
      tiempoIni=millis();
      if((estacionA+estacionB+estacionC)==1){
        
        if(estacionA==1){
          contadorLetra1=imprimirTexto(1,contadorLetra1);
          contadorLetra2=imprimirTexto(2,contadorLetra2);
          matrix.clearDisplay(1);
          matrix.clearDisplay(2);
          
        }else if(estacionB==1){
          contadorLetra1=imprimirTexto(0,contadorLetra1);
          contadorLetra2=imprimirTexto(2,contadorLetra2);
          matrix.clearDisplay(0);
          matrix.clearDisplay(2);
        }else if(estacionC==1){
          contadorLetra1=imprimirTexto(0,contadorLetra1);
          contadorLetra2=imprimirTexto(1,contadorLetra2);
          matrix.clearDisplay(0);
          matrix.clearDisplay(1);
        }
      }else if((estacionA+estacionB+estacionC)==2){
        if(estacionA==0){
          contadorLetra1=imprimirTexto(0,contadorLetra1);
          matrix.clearDisplay(0);
        }else if(estacionB==0){
          contadorLetra1=imprimirTexto(1,contadorLetra1);
          matrix.clearDisplay(1);
        }else if(estacionC==0){
          contadorLetra1=imprimirTexto(2,contadorLetra1);
          matrix.clearDisplay(2);
        }
      }
      
    }
    if (text.length()>0){
      if(text=="A"){ // Actualiza si ya ingreso contraseña correcta o no
        miBT.print(0); //Debo cambiar inicio a 1 cuando termine de correr la aplicacion o si preciono salir en la aplicacion   
        //text ="";
      }
      if (text =="D"){
        ReiniciarEstaciones();
        estacionA=0;
        estacionB=0;
        estacionC=0;
        contadorEstaciones==0;
        //lcd.clear(); 
      }
      if (text =="C"){
        btnAceptar=true;
        ReiniciarEstaciones();
        estacionA=0;
        estacionB=0;
        estacionC=0;
        contadorEstaciones==0;
        //lcd.clear(); 
      }
      
      if(text=="B"){ // Ya se dio continuar 2       
        condicionText="B";
        //lcd.clear();
        EstacionLoop();
      }else if (condicionText=="B"){
        //lcd.clear();
        EstacionLoop();
      }

    
      
      
     
      text ="";
      
  }
  
    
  }
  
    
    
}
