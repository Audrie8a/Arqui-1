#include <LiquidCrystal.h>

LiquidCrystal lcd(7, 6, 5, 4, 3, 2);
//Variables Control de Luces
bool CCLight=false;

//Habitaciones: Estado Inicial - Estados Actual 
int Hi1=0; int Ha1=0;
int Hi2=0; int Ha2=0;
int Hi3=0; int Ha3=0;
int Hi4=0; int Ha4=0;


void CheckControlLightStart(){
  lcd.begin(16,2);
}
int ldr=0;
void RecorrerHabitaciones(){
  for (int i=1; i<=4;i++){
    if (i==1){    //Habitacion 1
      ldr=analogRead(A0);
      Ha1=ldr;
      lcd.setCursor(1,0); 
      lcd.print("Habitacion 1:");
      if(ldr<=105){      
        lcd.setCursor(1,1);
        lcd.print("Luz Apagada");
        delay(3000);
      }else{              
        lcd.setCursor(1,1);
        lcd.print("Luz Encendida");
        delay(3000);
      }     
    }else if (i==2){
      ldr=analogRead(A1);
      Ha2=ldr;
      lcd.setCursor(1,0); 
      lcd.print("Habitacion 2:");
      if(ldr<=105){      
        lcd.setCursor(1,1);
        lcd.print("Luz Apagada");
        delay(3000);
      }else{              
        lcd.setCursor(1,1);
        lcd.print("Luz Encendida");
        delay(3000);
      }     
    }else if (i==3){
      ldr=analogRead(A2);
      Ha3=ldr;
      lcd.setCursor(1,0); 
      lcd.print("Habitacion 3:");
      if(ldr<=105){      
        lcd.setCursor(1,1);
        lcd.print("Luz Apagada");
        delay(3000);
      }else{              
        lcd.setCursor(1,1);
        lcd.print("Luz Encendida");
        delay(3000);
      }  
    }else if (i==4){
      ldr=analogRead(A3);
      Ha4=ldr;
      lcd.setCursor(1,0); 
      lcd.print("Habitacion 4:");
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

void setup() {
  // put your setup code here, to run once:
  
    CheckControlLightStart();
  
}

void loop() {
  // put your main code here, to run repeatedly:
  
    CheckControlLight(); 
}
