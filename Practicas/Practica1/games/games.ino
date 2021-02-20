#include "LedControl.h"
#include <MD_MAX72xx.h>
#include <MD_Parola.h>
#define HARDWARE_TYPE MD_MAX72XX::FC16_HW
#define MAX_DEVICES 2
#include <SPI.h>
#include <pt.h>
 
#include "LinkedListLib.h"
#define CP_PIN 10   //LOAD
#define DATA_PIN 11 //DIN
#define CLE_PIN 13  //CLK
struct pt hilo1,hilo2,hilo3,hilo4;
const int buttonPin0 = 7; //Modo Texto
const int buttonPin1 = 6; //Dirección
const int buttonPin2 = 5; //Velocidad 
const int buttonPin3 = 4; //Start 
const int buttonPin4 = 3; //Abajo
const int buttonPin5 = 2; //Arriba 
const int buttonPin6 = 8; //Derecha
const int buttonPin7 = 9; //Izquierda

LedControl lc = LedControl(DATA_PIN,CLE_PIN,CP_PIN,MAX_DEVICES);
LedControl matrix = LedControl(11, 13, 10, 2);
MD_Parola myDisplay = MD_Parola(HARDWARE_TYPE, DATA_PIN, CLE_PIN, CP_PIN, MAX_DEVICES);
/*void caracter_conDriver(int caracter[][8]) {
    for (int i = 0; i < 8; i++) {
        for (int j = 0; j < 8; j++) {
            if (caracter[i][j] == 1) {
                // TODO: matrix.setLed(number, row, column, state);
                matrix.setLed(0, i, j, HIGH);
            }
        }
        delay(2);
    }
}*/
//LETRERO-------------------------------------------------------------------------------------------------------

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
  //20 a 39 Va de izquierda a derecha
  { 1, "B   "},  { 0, "N B" },  { 1, "O N" },  { 0, "I  O" },  { 1, "C I" },
  { 0, "C C" },  { 1, "E C" },  { 0, "S E" },  { 1, "- S" },  { 1, "4 -" },
  { 0, "O 4" },  { 1, "P O" },  { 0, "U P" },  { 1, "R U" },  { 0, "G R" },
  { 1, "- G" },  { 0, "1  -" },  { 1, "P 1" },  { 0, "T P" },  { 1, "   T"}, 
  // 40 Juego       
  { 1, "Game Over" },
  //41
  { 0, "G A" },  { 1, "A M" },  { 0, "M E" },  { 1, "E  " },  { 0, "   O" },
  { 0, "O V" },  { 1, "V E" },  { 0, "E R" },  { 0, "R  " },
};


#define PAUSE_TIME  1000
#define MAX_STRINGS  (sizeof(M)/sizeof(M[0]))

void GameOverLetrero(){
  for (int j=41; j<49; j++){
    if(digitalRead(buttonPin3)!=LOW){
      myDisplay.setTextBuffer(M[j].msg);
        myDisplay.print(M[j].msg);
        //myDisplay.displayReset();
        delay(800);    
    }else{
      game_init();
     break;  
    }
        
  }
}

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
//LETRERO --------------------------------------------------------------------------------------------------------------------------------------------
void letrero(){
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

/************************************ JUEGOOOOOO  ******************************************/
bool jugado = false;
int tablero[16][8];
int tamano=2;
bool Abajo=false;
bool Arriba=false;
bool Izq = false;
bool Der =true;
struct snake{ // struct para la snake.
    int x ;
    int y ;
};
 
LinkedList<int> snakeey;
LinkedList<int> snakeex;
/*Thread myThread = Thread();
Thread movimiento_snake = Thread();
Thread pausa = Thread();*/


snake posicion1;//cabeza snake
snake posicion2;// cola snake
void colocar_alimento(){
   int x= random(16);
   int y=random(8);
   if(tablero[x][y]==0){
    tablero[x][y]=2;
   } 
   else {
    colocar_alimento();
   }
}

void iniciar_tablero(){
  //colocando snake.
  posicion1.x=4;
  posicion1.y=4;
  posicion2.x=5;
  posicion2.y=4;
 

  //colocando alimento.
 
  
  //para inicializar el tablero con 0
  for(int i = 0; i < 8; i++){
          for(int j = 0; j < 16; j++){
                tablero[j][i] = 0;
          }
   } 
 
 
   snakeex.InsertHead(4);//inserto valor a la linkedlist x
   snakeex.InsertHead(5);
   snakeey.InsertHead(4);//inserto valor a la linkedlist y
   snakeey.InsertHead(4);
   tablero[4][4]=1;//inicializando snake
   tablero[5][4]=1;//inicializando snake
   tablero[10][4]=2;//inicializando alimento
  //colocar_alimento();
  

 
}
void setup() {
  // put your setup code here, to run once:
    pinMode(buttonPin0, INPUT);
    pinMode(buttonPin1, INPUT);
    pinMode(buttonPin2, INPUT);
    pinMode(buttonPin3, INPUT);
    pinMode(buttonPin4, INPUT);
    pinMode(buttonPin5, INPUT);
    pinMode(buttonPin6, INPUT);
    pinMode(buttonPin7, INPUT);
    if(digitalRead(buttonPin3)==HIGH){
      game_init();
    }
    else{
      myDisplay.begin();
      myDisplay.displayClear();
      myDisplay.setIntensity(5);
      myDisplay.displayText(M[0].msg, PA_LEFT, velocidad, 0, PA_SCROLL_LEFT , PA_SCROLL_LEFT );
    }


   

    // HIGH (CATODO) | LOW (ANODO)
    
    
   // int dispositivos = lc.getDeviceCount();
    //for(int address=0;address<dispositivos;address++) {
     // lc.shutdown(address,false); // colocar o módulo em power-seving mode
     // lc.setIntensity(address,8); // setar o brilho - brilho médio
      //lc.clearDisplay(address); // limpar display
  
      //if(digitalRead(buttonPin3)==LOW){
        //myDisplay.displayText(M[0].msg, PA_LEFT, velocidad, 0, PA_SCROLL_LEFT , PA_SCROLL_LEFT );
      //}
    //}
 
   // 
 
}

void  mostrarMatrix()//mostrad led en ambas matriz
{
      for (int i = 0; i < 16; i++) {         
        if(i>7){
               for (int j = 0; j < 8; j++) {
                  if (tablero[i][j] >0) {
                  // TODO: matrix.setLed(number, row, column, state);
                   matrix.setLed(0, j,i-8 , true);  //enciende               
                   }else{   matrix.setLed(0, j,i-8 , false);  //apaga   
                   }
               }       
        }
        else{
          for (int j = 0; j < 8; j++) {
            if (tablero[i][j] >0) {
            // TODO: matrix.setLed(number, row, column, state);
               matrix.setLed(1, j, i, true);
            }else{    matrix.setLed(1, j, i, false);    }
          }
        }
          
        delay(2);//espera
    }
  }
boolean bandera=true;//validar para no crear muchos hilos
int dir=1;
int tiempoVelocidad=500;//velocidad con la que empieza el snake

void juego(struct pt *pt)// la funcion cambia el LED
{
  PT_BEGIN(pt);//inicio hilo
  if(Der==true || digitalRead(buttonPin6)==HIGH){derecha(); } //movimiento derecha
  else if (Izq==true || digitalRead(buttonPin7)==HIGH){izquierda();}//movimiento izquierda
  else if (Arriba==true || digitalRead(buttonPin5)==HIGH){arriba();}//movimiento arriba
  else if (Abajo==true || digitalRead(buttonPin4)==HIGH){abajo();}//movimiento abajo   
  tiempoVelocidad= tiempoVelocidad-3;
  delay(tiempoVelocidad);//velocidad de movimiento de la snake
  bandera=true;
  PT_END(pt);//finalizo hilo  
    
}
void movimientoSnake(int temx,int temy)//guardar el movimiento de la snake
{
  if(tablero[temx][temy]==0){//si espacio vacio
    // digitalWrite(2, HIGH);

     snakeex.InsertHead(temx);//guarda el nuevo valor de la snake en x de la linkedlist
     snakeey.InsertHead(temy);//guarda el nuevo valor de la snake en yde la linkedlist
     tablero[temx][temy]=1;//es snake
     tablero[snakeex.GetTail()][snakeey.GetTail()]=0;//obengo la cola para apagarla
     snakeey.RemoveTail();//delate cola
     snakeex.RemoveTail();//delate cola

       
   
 
 }else if(tablero[temx][temy]==1){//en caso de que se tope con ella misma, pierde
   //error
    myDisplay.displayClear();
    myDisplay.print("Game Over"); //mostrando gameover
    //digitalWrite(2, HIGH);
  }
  else if(tablero[temx][temy]==2)// en caso de que encuentre alimento
  {
     snakeex.InsertHead(temx);//inserto en la linkedlist
     snakeey.InsertHead(temy);
     tablero[temx][temy]=1;//lugar de la snake
     colocar_alimento();//agrego alimento
  }

}
void derecha(){
  int temx=snakeex.GetHead()+1;//obtengo cabeza muevo un espacio en x
  int temy=snakeey.GetHead();
  
  if(temx==16){//topo muere
    //error
    myDisplay.displayClear();
    GameOverLetrero();
    //myDisplay.print("Game Over"); 
    //digitalWrite(2, HIGH);
    return;
    }
    //metodo para agregar un valor al snake 
  movimientoSnake(temx,temy);
   Der=true;
   Izq=false;
   Arriba=false;
   Abajo=false;
}

void izquierda(){
  int temx=snakeex.GetHead()-1; //obtengo cabeza muevo un espacio en x
  int temy=snakeey.GetHead();
  
  if(temx==-1){
    //error
    myDisplay.displayClear();
    //myDisplay.print("Game Over"); 
    GameOverLetrero();
    //digitalWrite(2, HIGH);
    return;
    }
    //metodo para agregar un valor al snake 
  movimientoSnake(temx,temy);
   Izq=true;
    Der=false;
    Arriba=false;
    Abajo=false;
}

void arriba(){
  int temx=snakeex.GetHead();
  int temy=snakeey.GetHead()-1;
  
  if(temy==-1){
    //error
    myDisplay.displayClear();    
    myDisplay.setTextEffect(PA_SCROLL_LEFT,PA_SCROLL_LEFT);
    GameOverLetrero();
    //digitalWrite(2, HIGH);
    return;
    }
    //metodo para agregar un valor al snake 
  movimientoSnake(temx,temy);
   Arriba=true;
    Abajo=false;
    Der=false;
    Izq=false;
}
void abajo(){
  int temx=snakeex.GetHead();
  int temy=snakeey.GetHead()+1;//obtengo cabeza muevo un espacio en y
  
  if(temy==8){
    //error
    myDisplay.displayClear();
    GameOverLetrero();
    //myDisplay.print("Game Over"); 
    return;
    }
    //metodo para agregar un valor al snake 
  movimientoSnake(temx,temy);//obtengo cabeza muevo un espacio en y
   Abajo= true;
    Arriba=false;
    Izq=false;
    Der=false;
}
int contador=0;
void controles(){  
  //comida(contador);
  if (digitalRead(buttonPin5)==HIGH){ //Arriba
    contador++;
    //y--;  
    Arriba=true;
    Abajo=false;
    Der=false;
    Izq=false;
    //desplazarArriba();
  }else if (digitalRead(buttonPin4)==HIGH){ //Abajo
    contador++;
    //y--;
    Abajo= true;
    Arriba=false;
    Izq=false;
    Der=false;
    //desplazarAbajo();
  }else if (digitalRead(buttonPin6)==HIGH){ //Derecha
    contador++;
    //x++;
    Der=true;
    Izq=false;
    Arriba=false;
    Abajo=false;
   // desplazarDerecha();
  }else if (digitalRead(buttonPin7)==HIGH){ //Izquierda
    contador++;
    //x--;
    Izq=true;
    Der=false;
    Arriba=false;
    Abajo=false;
    //desplazarIzquierda();
  }
} 
 
 

void game_init(){
      jugado=true;
      matrix.shutdown(0, false);//saliendo del modo apagado
      matrix.shutdown(1, false);
      matrix.setIntensity(0, 8);// establece un brillo medio para los Leds 
      matrix.setIntensity(1, 8);
      matrix.clearDisplay(0);
      matrix.clearDisplay(1);
      pinMode(2, OUTPUT);
      digitalWrite(2, LOW);
      myDisplay.begin();
      myDisplay.displayClear();
      myDisplay.setIntensity(5);
      myDisplay.displayText(M[0].msg, PA_LEFT, velocidad, 0, PA_SCROLL_LEFT , PA_SCROLL_LEFT );
      
      PT_INIT(&hilo1);//inicializando hilo
      iniciar_tablero();
}
 
void loop() {
  // put your main code here, to run repeatedly:
  if(digitalRead(buttonPin3)==HIGH){
    controles();
    if(jugado==false){
      game_init();
    }else{
      if(bandera){//no crear muchos hilos 
        bandera=false;
        juego(&hilo1);
      }
      mostrarMatrix();
    }
  }
  else {
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

}



 
