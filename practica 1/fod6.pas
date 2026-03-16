program ejercicio6;
  
type
  rango = 'a'..'d';

  celular = record
    cod, stock_min, stock_dispo: integer;
    nombre, descripcion, marca: string;
    precio: real;
  end;
  
  archivo = file of celular;
  texto = text;
  
  //5a
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
    
  //5b
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
    
  //5c
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
    
  //5d
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
    
  //6a
  procedure punto6A(var arch: archivo);
    var
      cel: celular;
      
    begin
      reset(arch);
      seek(arch, filesize(arch));
      
      readln(cel.cod);
      readln(cel.precio);
      readln(cel.marca);
      readln(cel.stock_dispo);
      readln(cel.stock_min);
      readln(cel.descripcion);
      readln(cel.nombre);
      
      write(arch, cel);
      
      close(arch);
    end;
    
  //6b
  procedure punto6b(var arch: archivo);
    var
      cel: celular;
      ok: boolean;
      nombre: string;
      
    begin
      readln(nombre);
      ok := true;
      
      reset(arch);
      
      while(not(EOF(arch))) and (ok) do
        begin
          read(arch, cel);
          
          if (cel.nombre = nombre) then
            begin
              ok := false;
              seek(arch, filepos(arch)-1);
              cel.stock_dispo := cel.stock_dispo -1; //modifica, fin
              
              write(arch, cel);
            end;        
        end;
      close(arch);
    end;
    
  //6 c
  procedure punto6c(var arch: archivo; var arch2: texto);
    var
      cel: celular;
    begin
      reset(arch);
      rewrite(arch2);
      
      while (not(EOF(arch))) do
        begin
          read(arch, cel);
          
          if (cel.stock_dispo = 0) then
            begin
              writeln(arch2, cel.cod, ' ', cel.precio, ' ', cel.marca);
              writeln(arch2, cel.stock_dispo, ' ', cel.stock_min, ' ', cel.descripcion);
              writeln(arch2, cel.nombre);
            end;
        end;
      close(arch);
      close(arch2);    
    end;
  
var
  archivo_logico: archivo;
  txt, txt2: texto;
  nombre: string;
  op: rango;
  
begin
  assign(txt, 'celulares.txt');
  writeln('ingrese un nombre: '); readln(nombre);
  assign(archivo_logico, nombre);
  assign(txt2, 'SinStock.txt');
    
  write('ingrese una opcion (a,b,c,d): '); //lo hago sencillo
  readln(op);
  case (op) of
    'a': puntoA(archivo_logico, txt);
    'b': puntoB(archivo_logico);
    'c': puntoC(archivo_logico);
    'd': puntoD(archivo_logico, txt);
  end;
end.


