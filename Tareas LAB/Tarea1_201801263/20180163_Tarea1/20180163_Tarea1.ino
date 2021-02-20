// DECLARACIÓN DE VARIABLES

//Declaración de los pines de los LED
  byte led1 = 2;
  byte led2 = 3;
  byte led3 = 4;
  
int i; //Varaible del Contador del FOR
long vel=100; //Velocidad de las Luces (está en milisegundos)

void setup() {
  //For para configurar cada led como salida (output)
  for(i=led1; i<=led3; i++){
      pinMode(i,OUTPUT);
    }
  

}

void loop() {
  
  //Prende los LED de un solo (0, false, LOW)
  digitalWrite(led1,1);
  digitalWrite(led2,1);
  digitalWrite(led3,1);
  delay(200);

  //Apaga los LED de un solo (0, false, LOW)
  digitalWrite(led1,0);
  digitalWrite(led2,0);
  digitalWrite(led3,0);
  delay(200);

  //Enciende los LED de izquierda a Derecha
  for (i=led1; i<=led3; i++){
    digitalWrite(i,1); //Enciende el LED (1, HIGH,true)
    delay(vel);       //Retardo (Espera el valor de vel)
    }

  //Apaga los LED de izquierda a Derecha
  for (i=led3; i>=led1; i--){
    digitalWrite(i,0); //Enciende el LED (1, HIGH,true)
    delay(vel);       //Retardo (Espera el valor de vel)
    }

   //Prende los LED de un solo (0, false, LOW)
  digitalWrite(led1,1);
  digitalWrite(led2,1);
  digitalWrite(led3,1);
  delay(200);

  //Apaga los LED de un solo (0, false, LOW)
  digitalWrite(led1,0);
  digitalWrite(led2,0);
  digitalWrite(led3,0);
  delay(200);
}
