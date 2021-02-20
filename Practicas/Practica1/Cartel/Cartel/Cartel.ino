
#include <MD_Parola.h>
#include <MD_MAX72xx.h>
#include <SPI.h>

//Aclaraciones: Modulo 0= Matriz 2 ; Modulo 1= Matriz 1

#define HARDWARE_TYPE MD_MAX72XX::FC16_HW
#define MAX_DEVICES 2

#define CP_PIN 10   //LOAD
#define DATA_PIN 11 //DIN
#define CLE_PIN 13  //CLK

MD_Parola myDisplay = MD_Parola(HARDWARE_TYPE, DATA_PIN, CLE_PIN, CP_PIN, MAX_DEVICES);

const int buttonPin0 = 7; //Modo Texto
const int buttonPin1 = 6; //Dirección
const int buttonPin2 = 5; //Velocidad 
int velocidad=100;
int retardo=800;
int curText=0;

//0 a 21 Cadenas
const char *pc[]=
{
  "TP1-GRUPO 4-SECCION B",
  "T", "P", "1", "-",
  "G", "R", "U", "P", "O",
  " ", "4", "-", "S", "E", 
  "C", "C", "I", "O", "N",
  " ", "B" 
};


// Global variables
typedef struct
{
  uint8_t spacing;  // character spacing
  const char *msg;  // message to display
} msgDef_t;


msgDef_t  M[] =
{
  { 1, "TP1-GRUPO 4-SECCION B"},
  //1 a 19 Va de derecha a izquierda
  { 0, "   T"},  { 1, "T P" },  { 0, "P 1" },  { 1, "1  -" },  { 0, "- G" },
  { 1, "G R" },  { 0, "R U" },  { 1, "U P" },  { 0, "P O" },  { 1, "O 4" },
  { 0, "4 S" },  { 1, "S E" },  { 0, "E C" },  { 1, "C C" },  { 0, "C I" },
  { 1, "I  O" },  { 0, "O N" },  { 1, "N B" },  { 0, "B  " },
  //20 a 30 Va de izquierda a derecha
  { 1, "B   "},  { 0, "N B" },  { 1, "O N" },  { 0, "I  O" },  { 1, "C I" },
  { 0, "C C" },  { 1, "E C" },  { 0, "S E" },  { 1, "- S" },  { 1, "4 -" },
  { 0, "O 4" },  { 1, "P O" },  { 0, "U P" },  { 1, "R U" },  { 0, "G R" },
  { 1, "- G" },  { 0, "1  -" },  { 1, "P 1" },  { 0, "T P" },  { 1, "   T"},        
          
          
        
};


#define PAUSE_TIME  1000
#define MAX_STRINGS  (sizeof(M)/sizeof(M[0]))

int modoStatic(int cont){ 
  int n=cont;
  if (digitalRead(buttonPin1)==HIGH){
    if(n<20){
    myDisplay.setTextEffect(PA_NO_EFFECT,PA_NO_EFFECT );
    myDisplay.setTextBuffer(M[n].msg);
    myDisplay.displayReset();  
    delay(retardo);
    myDisplay.displayReset();
    n = (n + 1) % MAX_STRINGS;
    }else{
      n=1;
      myDisplay.displayReset();
    }
  }else{
    if (n<20){
      n=20;  
    }
    myDisplay.setTextAlignment(PA_RIGHT,PA_LEFT);
    myDisplay.setTextEffect(PA_NO_EFFECT,PA_NO_EFFECT ); 
    myDisplay.setTextBuffer(M[n].msg);
    myDisplay.displayReset();
    delay(retardo);
    myDisplay.displayReset();
    n = (n + 1) % MAX_STRINGS;
  }
  
  return n;
}

void modoAnimado(){
  myDisplay.setTextEffect(PA_SCROLL_LEFT,PA_SCROLL_LEFT);
  myDisplay.setTextBuffer(M[0].msg);
  if (digitalRead(buttonPin1)==HIGH) {
    myDisplay.setTextEffect(PA_SCROLL_LEFT , PA_SCROLL_LEFT); 
  }else{
    myDisplay.setTextEffect(PA_SCROLL_RIGHT, PA_SCROLL_RIGHT);
  }  
  int slide_scroll_speed = map(velocidad, 1023, 0, 400, 15);
  myDisplay.setSpeed(slide_scroll_speed);
}





void setup() {
  // put your setup code here, to run once:

  
  pinMode(buttonPin0, INPUT);
  pinMode(buttonPin1, INPUT);
  pinMode(buttonPin2, INPUT);

  myDisplay.begin();
  myDisplay.displayClear();
  myDisplay.setIntensity(5);
  myDisplay.displayText(M[0].msg, PA_LEFT, velocidad, 0, PA_SCROLL_LEFT , PA_SCROLL_LEFT );
}

void loop() {
  // put your main code here, to run repeatedly:
  static uint8_t  n = 1;
  if (digitalRead(buttonPin0)==HIGH){
      n=modoStatic(n);
    } else{      
      modoAnimado();
      n=1;
    }
    
    if (digitalRead(buttonPin2)==HIGH) {
      velocidad = 80; 
      retardo= 600;
    }else{
      velocidad = 1000; 
      retardo=1000;
    }

  if (myDisplay.displayAnimate())
  {   
    myDisplay.displayReset();    
  }
}
