{
8. Se cuenta con un archivo con información de las diferentes distribuciones de linux
existentes. De cada distribución se conoce: nombre, año de lanzamiento, número de
versión del kernel, cantidad de desarrolladores y descripción. El nombre de las
distribuciones no puede repetirse. Este archivo debe ser mantenido realizando bajas
lógicas y utilizando la técnica de reutilización de espacio libre llamada lista invertida.

Escriba la definición de las estructuras de datos necesarias y los siguientes
procedimientos:

a. ExisteDistribucion: módulo que recibe por parámetro un nombre y devuelve
verdadero si la distribución existe en el archivo o falso en caso contrario.

b. AltaDistribución: módulo que lee por teclado los datos de una nueva
distribución y la agrega al archivo reutilizando espacio disponible en caso
de que exista. (El control de unicidad lo debe realizar utilizando el módulo
anterior). En caso de que la distribución que se quiere agregar ya exista se
debe informar “ya existe la distribución”.

c. BajaDistribución: módulo que da de baja lógicamente una distribución
cuyo nombre se lee por teclado. Para marcar una distribución como
borrada se debe utilizar el campo cantidad de desarrolladores para
mantener actualizada la lista invertida. Para verificar que la distribución a
borrar exista debe utilizar el módulo ExisteDistribucion. En caso de no existir
se debe informar “Distribución no existente”.
}

program ejercicio8;

type
  distribucion= record
    nombre, descripcion: string;
    anio_lanz, nro_karnel, cant_desarr: integer;
  end;

  archivo = file of distribucion;

  procedure ExisteDistribucion(var a: archivo; nom: string; var ok: boolean);
    var
      d: distribucion;
     
    begin
      reset(a);
      ok := false; // Inicializo siempre en falso
      
      { Saltamos la cabecera (pos 0) porque ahí no hay nombres de Linux }
      if not EOF(a) then
        seek(a, 1);
      
      while (not(EOF(a))) and (ok = false) do
        begin
          read(a, d);
         
          if (d.nombre = nom) then
            ok := true;
        end;
       close(a);
     end;
    
  procedure leer(var d: distribucion);
    begin
      readln(d.nombre);
      readln(d.descripcion);
      readln(d.anio_lanz);
      readln(d.nro_karnel);
      readln(d.cant_desarr);
    end;

procedure AltaDistribucion(var a: archivo);
var
  d, cabecera, d_aux: distribucion;
  existe: boolean;
begin
  writeln('Ingrese el nombre de la distribucion a dar de alta:');
  readln(d.nombre);
  
  ExisteDistribucion(a, d.nombre, existe);
  
  if (existe) then
    writeln('Ya existe la distribucion')
  else
    begin
      leer(d); // Leemos el resto de los campos
      reset(a);
      read(a, cabecera); // La cabecera está en la pos 0
      
      if (cabecera.cant_desarr = 0) then
        begin
          { No hay huecos: al final del archivo }
          seek(a, filesize(a));
          write(a, d);
        end
      else
        begin
          { Reutilizamos el hueco que indica la cabecera }
          { Convertimos el indice negativo a positivo para el seek }
          seek(a, cabecera.cant_desarr * -1); 
          
          { Antes de pisar el hueco, leemos qué "flecha" (enlace) tenía }
          read(a, d_aux); 
          
          { Actualizamos la cabecera con el siguiente enlace de la lista }
          seek(a, 0);
          write(a, d_aux);
          
          { Ahora sí, grabamos la nueva distribución en el hueco }
          seek(a, cabecera.cant_desarr * -1);
          write(a, d);
        end;
      close(a);
    end;
end;

procedure BajaDistribucion(var a: archivo);
var
  d, cabecera: distribucion;
  nombre_baja: string;
  existe: boolean;
  pos_a_borrar: integer;
begin
  writeln('Ingrese el nombre de la distribucion a dar de baja:');
  readln(nombre_baja);
  
  { 1. Verificamos existencia con el modulo del punto A }
  ExisteDistribucion(a, nombre_baja, existe);
  
  if (not existe) then
    writeln('Distribucion no existente')
  else
    begin
      reset(a);
      { 2. Buscamos la posicion del registro para obtener su indice }
      { Saltamos la cabecera }
      read(a, cabecera); 
      
      while (not EOF(a)) do
        begin
          read(a, d);
          { Importante: Solo borramos si el registro esta activo (cant_desarr >= 0) }
          if (d.nombre = nombre_baja) and (d.cant_desarr >= 0) then
            begin
              pos_a_borrar := (filepos(a) - 1);
              
              { PASO A: Volvemos a la cabecera para ver cual era el proximo hueco }
              seek(a, 0);
              read(a, cabecera);
              
              { PASO B: El registro que borramos ahora apunta al que antes era el primer hueco }
              { Usamos cant_desarr para guardar este puntero negativo }
              d.cant_desarr := cabecera.cant_desarr; 
              
              { Grabamos el registro marcado en su posicion original }
              seek(a, pos_a_borrar);
              write(a, d);
              
              { PASO C: La cabecera (pos 0) ahora apunta a este nuevo hueco }
              { Guardamos la posicion actual como un numero negativo }
              cabecera.cant_desarr := (pos_a_borrar * -1);
              seek(a, 0);
              write(a, cabecera);
              
              writeln('Baja realizada. El espacio sera reutilizado.');
              break; { Salimos del bucle al encontrarlo }
            end;
        end;
      close(a);
    end;
end;

var
  arc: archivo;
  opcion: integer;
begin
  assign(arc, 'distribuciones.dat');

  { Nota: El archivo debe estar inicializado con un registro 
    en la pos 0 que tenga cant_desarr = 0 para que funcione }

  repeat
    writeln;
    writeln('--- MENU ---');
    writeln('1. Alta de Distribucion');
    writeln('2. Baja de Distribucion');
    writeln('0. Salir');
    write('Opcion: ');
    readln(opcion);

    case opcion of
      1: AltaDistribucion(arc);
      2: BajaDistribucion(arc);
    end;
  until opcion = 0;
end.

///////////LO HIZO GEMINI, YA ME CANSO ESTO
