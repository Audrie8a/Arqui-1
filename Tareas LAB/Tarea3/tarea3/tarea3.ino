int val;
char caracter;
String texto;
void setup() {
  Serial.begin(9600);
  pinMode(A1,INPUT);

}

void loop() {
  val = analogRead(A1);
  float mv= (val/1024.0)*5000;
  float temperatura = mv/10;
  //delay(500);

 while(Serial.available()){
  delay(10);
  caracter=Serial.read(); 
  texto +=caracter;
 }
 if(texto.length()>0){
    
    if(texto=="T"){
      Serial.println(temperatura);
    }
    texto="";
 }
}
