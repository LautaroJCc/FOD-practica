program ejercicio5;
  
type
  rango = 'a'..'d';

  celular = record
    cod, stock_min, stock_dispo: integer;
    nombre, descripcion, marca: string;
    precio: real;
  end;
  
  archivo = file of celular;
  texto = text;
  
  //a
  procedure puntoA(var arch: archivo; var arch2: texto);
    var
      cel: celular;
      
    begin
      reset(arch2);
      rewrite(arch);
      
      while (not(EOF(arch2))) do
        begin
          readln(arch2, cel.cod, cel.precio, cel.marca);
          readln(arch2, cel.stock_dispo, cel.stock_min, cel.descripcion);
          readln(arch2, cel.nombre);
          
          write(arch, cel);    
        end;
      close(arch);
      close(arch2);
    end;
    
  //b
  procedure puntoB(var arch: archivo);
    var
      cel: celular;
      
    begin
      reset(arch);
      
      while (not(EOF(arch))) do
        begin
          read(arch, cel);
          
          if (cel.stock_dispo < cel.stock_min) then
            begin
              writeln(cel.cod, ' ', cel.precio, ' ', cel.marca, ' ');
              writeln(cel.stock_dispo, ' ', cel.stock_min, ' ', cel.descripcion, ' ');
              writeln(cel.nombre);
              writeln('');
            end;
        end;
      close(arch);
    end;
    
  //c
  procedure puntoC(var arch: archivo);
    var
      cel: celular;
      desc: string;
      
    begin
      reset(arch);
      
      write('ingrese una descripcion: ');
      readln(desc);
      while (not(EOF(arch))) do
        begin
          read(arch, cel);
  
          if (desc = cel.descripcion) then //ver este mas adelante
            begin
              writeln(cel.cod, ' ', cel.precio, ' ', cel.marca, ' ');
              writeln(cel.stock_dispo, ' ', cel.stock_min, ' ', cel.descripcion, ' ');
              writeln(cel.nombre);
              writeln('');
            end;
        end;
      close(arch);
    end;
    
  //d
  procedure puntoD(var arch: archivo; var arch2: texto);
    var
      cel: celular;
    begin
      reset(arch);
      rewrite(arch2);
      
      while (not(EOF(arch))) do
        begin
          read(arch, cel);
          
          writeln(arch2, cel.cod, ' ', cel.precio, ' ', cel.marca);
          writeln(arch2, cel.stock_dispo, ' ', cel.stock_min, ' ', cel.descripcion);
          writeln(arch2, cel.nombre);
        end;
      close(arch);
      close(arch2);    
    end;
  
var
  archivo_logico: archivo;
  txt: texto;
  nombre: string;
  op: rango;
  
begin
  assign(txt, 'celulares.txt');
  writeln('ingrese un nombre: '); readln(nombre);
  assign(archivo_logico, nombre);
    
  write('ingrese una opcion (a,b,c,d): '); //lo hago sencillo
  readln(op);
  case (op) of
    'a': puntoA(archivo_logico, txt);
    'b': puntoB(archivo_logico);
    'c': puntoC(archivo_logico);
    'd': puntoD(archivo_logico, txt);
  end;
end.
