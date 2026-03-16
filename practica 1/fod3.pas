program ejercicio3;

const
  edad_max = 70;
  
type
  empleado = record
    nro, edad, dni: integer;
    apellido, nombre: string;
  end;
  
  archivo = file of empleado;
  
  procedure leer(var e: empleado);
    begin
      write('ingrese apellido: ');
      readln(e.apellido);
      
      if (e.apellido <> 'fin') then
        begin
          write('ingrese nombre: '); readln(e.nombre);
          write('ingrese nro: '); readln(e.nro);
          write('ingrese edad: '); readln(e.edad);
          write('ingrese dni: '); readln(e.dni);
        end;
    end;
    
  procedure topicoA(var arch: archivo); //a
    var 
      e: empleado;
    begin
      rewrite(arch);
      
      leer(e);
      while (e.apellido <> 'fin') do
        begin
          write(arch, e);
          leer(e);
        end;
      close(arch);
    end;
  
  procedure mostrarDatos(e: empleado);
    begin
      writeln(e.apellido);
      writeln(e.nombre);
      writeln(e.dni);
      writeln(e.edad);
      writeln(e.nro);
    end;
    
  procedure topicoBi(var arch: archivo);
    var 
      e: empleado;
      dato: string;
    begin
      reset(arch);
      
      writeln('ingrese un nombre o apelliudo determinado: '); readln(dato);
      while (not(EOF(arch))) do
        begin
          read(arch, e);
          if ((e.nombre = dato) or (e.apellido = dato)) then
            mostrarDatos(e);
        end;   
      close(arch);
    end;
  
  procedure topicoBii(var arch: archivo);
    var
      e: empleado;
    begin
      reset(arch);
      while (not(EOF(arch))) do
        begin
          read(arch, e);
          writeln(e.apellido, ' ', e.nombre, ' ', e.edad, ' ', e.dni, ' ', e.nro); //DE A UNO POR LINEAAAAAAAA
        end;
      close(arch);
    end;
    
  procedure topicoBiii(var arch: archivo);
    var 
      e: empleado;
    begin
      reset(arch);
      
      while (not(EOF(arch))) do
        begin
          read(arch, e);
          if (e.edad > edad_max) then
            mostrarDatos(e);
        end;   
      close(arch);
    end;
    
  
var
  archivo_logico: archivo;
  nombre: string; 
  topico: char;
  num: integer;
  
begin
  write('ingrese un nombre para el archivo: '); readln(nombre);
  assign(archivo_logico, nombre);
  
  writeln('ingrese un topico: '); readln(topico);
  
  //el menu lo hice rapido, no me interesa, que funcione asi nomas, lo otro es lo mas importante
  if (topico = 'B') or (topico = 'b') then
    begin
      readln(num);
      if (num = 1) then
        topicoBi(archivo_logico)
      else if (num = 2) then
        topicoBii(archivo_logico)
      else
        topicoBiii(archivo_logico);
    end
  else
    topicoA(archivo_logico);

end.
  
  
 
 
