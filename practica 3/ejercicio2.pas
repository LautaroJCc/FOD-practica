{
2. Definir un programa que genere un archivo con registros de longitud fija conteniendo
información de asistentes a un congreso a partir de la información obtenida por
teclado. Se deberá almacenar la siguiente información: nro de asistente, apellido y
nombre, email, teléfono y D.N.I. Implementar un procedimiento que, a partir del
archivo de datos generado, elimine de forma lógica todos los asistentes con nro de
asistente inferior a 1000.
Para ello se podrá utilizar algún carácter especial situándolo delante de algún campo
String a su elección. Ejemplo: ‘@Saldaño’.
}

program ejercicio2;

const
  corte = 1000;
  
type
  asistente = record
    nro, telefono, dni: integer; //deberian de ser strings?
    ape, nombre: string[20];
    correo: string[50];
  end;
  
  archivo = file of asistente;
  
  procedure leerAsistente(var a: asistente);
    begin
      writeln('Ingrese nro de asistente (-1 para terminar): ');
      readln(a.nro);
  
      if (a.nro <> -1) then
        begin
          writeln('Ingrese apellido: ');
          readln(a.ape);
      
          writeln('Ingrese nombre: ');
          readln(a.nombre);
       
          writeln('Ingrese email: ');
          readln(a.correo);
      
          writeln('Ingrese telefono: ');
          readln(a.telefono);
      
          writeln('Ingrese DNI: ');
          readln(a.dni);
       end;
    end;
    
  procedure crearArchivo(var arch: archivo);
    var
      a: asistente;
    begin
      rewrite(arch); // crea el archivo desde cero
  
      leerAsistente(a);
      while (a.nro <> -1) do
        begin
          write(arch, a);
          leerAsistente(a);
        end;
    
      close(arch);
    end;
  
  procedure baja(var arch: archivo);
    var
      a: asistente;
    
    begin
      reset(arch); // [IMPORTANTE] Abre el archivo y pone el puntero en el inicio
      while (not(EOF(arch))) do //pude hacer modulo leer
        begin
          read(arch, a);
          if (a.nro < corte) then
            begin
              a.correo := '@'+a.correo;    // que pasa si el correo tiene sus 50 caracteres???????? pds: es una marca de borrado
              seek(arch, filepos(arch)-1);
              write(arch, a);
            end; 
        end;
      close(arch);
    end;
    
var
  arch: archivo;

begin
  assign(arch, 'asistente');
  
  crearArchivo(arch);  // primero lo generás
  baja(arch);          // después hacés la baja lógica
end.

  
