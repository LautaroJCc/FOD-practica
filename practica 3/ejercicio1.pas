{
1. Modificar el ejercicio 4 de la práctica 1 (programa de gestión de empleados),
agregándole una opción para realizar bajas copiando el último registro del archivo en
la posición del registro a borrar y luego truncando el archivo en la posición del último
registro de forma tal de evitar duplicados.
}

program ejercicio4;

const
  edad_max = 70;
  dni_no = 00;
  
type
  empleado = record
    nro, edad, dni: integer;
    apellido, nombre: string;
  end;
  
  archivo = file of empleado;
  texto = text;
  
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
    
    //4 a
  procedure agregar(var arch: archivo);
    var
      e, e2: empleado;
      ok: boolean;
      
    begin
      ok := true;
      
      reset(arch);
      
      leer(e2);
      while (e2.apellido <> 'fin') do
        begin
          while (not(EOF(arch))) and (ok) do
            begin   
              read(arch, e);
              if (e2.nro = e.nro) then
                ok := false;
              
            end;     
   
          if (ok) then
            begin
              seek(arch, filesize(arch));
              write(arch, e2);
            end;
            
          leer(e2);
          ok := true;
          seek(arch,0); // volver al inicio
        end;
      close(arch);
    end;
    
  //4 b
  procedure modificar(var arch: archivo);
    var
      e: empleado;
      num: integer;
      ok: boolean;
    begin
      readln(num);
      ok:=true;
      reset(arch);
      
      while (not(EOF(arch))) and (ok) do
        begin
          read(arch, e);
          if (e.nro = num) then
            begin
              ok := false;
              e.edad := e.edad +1;  //modifico edad
              seek(arch, filepos(arch)-1);
              write(arch, e); 
            end;
        end;
        
      close(arch);
    end;
    
  //4 c
  procedure pasarAtexto(var arch: archivo; var arch2: texto);
    var
      e: empleado;
      
    begin
      rewrite(arch2); {crea archivo de texto}
      reset(arch);    {abre archivo binario}
      
      while (not(EOF(arch))) do
        begin
          read(arch, e); //leo el arch actual
          
          writeln(arch2, e.nro, ' ',e.edad,' ',e.apellido,' ',e.nombre, ' ', e.dni); //paso a arch2 lo de arch
        end;
      close(arch);
      close(arch2);
    end;
    
  //4 d
  procedure punto4d(var arch: archivo; var arch2: texto);
    var 
      e: empleado;
      
    begin
      reset(arch);
      rewrite(arch2);
      
      while (not(EOF(arch))) do
        begin
          read(arch, e);
          
          if (e.dni = dni_no) then
            writeln(arch2, e.nro, ' ',e.edad,' ',e.apellido,' ',e.nombre, ' ', e.dni); 
        end;
      close(arch);
      close(arch2);
    end;
  
  {1. Modificar el ejercicio 4 de la práctica 1 (programa de gestión de empleados),
agregándole una opción para realizar bajas copiando el último registro del archivo en
la posición del registro a borrar y luego truncando el archivo en la posición del último
registro de forma tal de evitar duplicados.}
  //P3 1
  procedure baja(var arch: archivo; dni: integer);
    var
      e, e_aux: empleado;
      ok: boolean;
      aux: integer;
    begin
      ok := true;
      reset(arch); // Siempre abrir el archivo antes de recorrerlo
      while (not(EOF(arch)) and (ok)) do
        begin
          read(arch, e);
          if (e.dni = dni) then // Si el registro a borrar es el último, simplemente se trunca el archivo.
            begin
              ok := false;
              if (filepos(arch)  = filesize(arch)-1) then
                begin
                  seek(arch, filepos(arch));
                  truncate(arch);
                end
              else // Si no, se copia el último registro en la posición a borrar y luego se trunca el archivo para evitar dejar duplicados.
                begin
                  aux := filepos(arch) -1;
                  seek(arch, filesize(arch) - 1);
                  read(arch, e_aux);
                  seek(arch, aux);
                  write(arch, e_aux);
                  seek(arch, filesize(arch) - 1);
                  truncate(arch);
                end;
            end;
        end;
      close(arch); 
    end;
  
var
  archivo_logico: archivo;
  txt, txt2: texto;
  nombre: string; 
  topico: char;
  num, dni: integer;
  
begin
  write('ingrese un nombre para el archivo: '); readln(nombre);
  assign(archivo_logico, nombre);
  assign(txt, 'todos_empleados.txt');
  assign(txt2, 'faltaDNIEmpleado.txt');
  
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
  else if (topico = 'A') or (topico = 'a') then
    topicoA(archivo_logico)
  else
    begin
      readln(dni);
      baja(archivo_logico, dni);
    end;
end.
  
  
 
 
