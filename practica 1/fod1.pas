program ejercicio1;

const
  corte = 30000;
  
type
  archivo = file of integer;
  
var
  nombre: string;
  num: integer;
  archivo_logico: archivo;
  
begin
  write('ingrese nombre del archivo: ');
  readln(nombre);
  
  assign(archivo_logico, nombre); //conecta una var con un archivo fisico
  rewrite(archivo_logico); //crea archivo
  
  write('ingrese un numero para ingresar en el archivo: ');
  readln(num);
  
  while (num <> 30000) do
    begin
      write(archivo_logico, num);
      write('ingrese un numero para ingresar en el archivo: ');
      readln(num);
    end;
    
  close(archivo_logico);
end.
  
  
