program ejercicio2;

const
  max = 1500;

type
  archivo = file of integer;
  
var
  nombre_logico: archivo;
  num, cont, total, suma: integer;
  nombre: string;
  
begin
  write('ingrese nombre del archivo: ');
  readln(nombre);

  assign(nombre_logico, nombre);
  reset(nombre_logico);
  
  suma := 0;
  total := 0;
  cont := 0;
  while (not(EOF(nombre_logico))) do
    begin
      read(nombre_logico, num);
      
      writeln(num);
      
      suma := suma + num;
      total := total +1;
      if (num < max) then
        cont := cont +1;
    end;
    
  close(nombre_logico);
  
  writeln('cant total de numeros menores a 1500: ', cont);
  writeln('promedio: ', (suma/total):0:2); //div por 0, ignorar mientras
end.
