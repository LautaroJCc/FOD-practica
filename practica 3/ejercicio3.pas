{
3. Realizar un programa que genere un archivo de novelas filmadas durante el presente año. De cada novela se registra: código, género,
nombre, duración, director y precio. El programa debe presentar un menú con las siguientes opciones:

a. Crear el archivo y cargarlo a partir de datos ingresados por teclado. Se utiliza la técnica de lista invertida para recuperar espacio libre en el
archivo. Para ello, durante la creación del archivo, en el primer registro del mismo se debe almacenar la cabecera de la lista. Es decir un registro
ficticio, inicializando con el valor cero (0) el campo correspondiente al código de novela, el cual indica que no hay espacio libre dentro del
archivo.

b. Abrir el archivo existente y permitir su mantenimiento teniendo en cuenta el inciso a., se utiliza lista invertida para recuperación de espacio. En
particular, para el campo de  ́enlace ́ de la lista, se debe especificar los números de registro referenciados con signo negativo, (utilice el código de
novela como enlace).Una vez abierto el archivo, brindar operaciones para:

i. Dar de alta una novela leyendo la información desde teclado. Para esta operación, en caso de ser posible, deberá recuperarse el
espacio libre. Es decir, si en el campo correspondiente al código de novela del registro cabecera hay un valor negativo, por ejemplo -5,
se debe leer el registro en la posición 5, copiarlo en la posición 0 (actualizar la lista de espacio libre) y grabar el nuevo registro en la
posición 5. Con el valor 0 (cero) en el registro cabecera se indica que no hay espacio libre.

ii. Modificar los datos de una novela leyendo la información desde teclado. El código de novela no puede ser modificado.

iii. Eliminar una novela cuyo código es ingresado por teclado. Por ejemplo, si se da de baja un registro en la posición 8, en el campo
código de novela del registro cabecera deberá figurar -8, y en el registro en la posición 8 debe copiarse el antiguo registro cabecera.

c. Listar en un archivo de texto todas las novelas, incluyendo las borradas, que representan la lista de espacio libre. El archivo debe llamarse “novelas.txt”.

NOTA: Tanto en la creación como en la apertura el nombre del archivo debe ser
proporcionado por el usuario.
}

program ejercicio3;

type
  novela2026 = record
    cod, duracion: integer;
    gen, nombre, director: string;
    precio: real;
  end;
  
  archivo = file of novela2026;
  
  procedure leer(var n: novela2026);
    begin
      readln(n.cod);
      readln(n.duracion);
      readln(n.gen);
      readln(n.nombre);
      readln(n.director);
      readln(n.precio);
    end;
  
  procedure puntoA(var arch: archivo);
    var
      n: novela2026;
    begin
      rewrite(arch);
      n.cod := 0;
      write(arch, n);
      
      leer(n);
      while (n.cod <> 0) do
        begin    
          write(arch, n);
          leer(n);
        end;
      close(arch);
    end;
    
  procedure puntoB(var arch: archivo);
    var
      punto: char;
      n, n_aux: novela2026;
      pos_libre, cod, pos: integer;
      ok: boolean;
      
    begin
      reset(arch);
      readln(punto);
      
      case (punto) of 
        'i': begin
               //dar de alta
               leer(n);
               if (not(EOF(arch))) then
                 begin
                   read(arch, n_aux);
                   if (n_aux.cod = 0) then //no hay espacio libre(liberado?)
                     begin
                       seek(arch, filesize(arch));
                       write(arch, n)
                     end
                     
                   else  //hay espacio libre
                     begin
                       pos_libre := n_aux.cod * -1;
                       
                       seek(arch, pos_libre); { 1. Voy al hueco }
                       read(arch, n_aux);
                       
                       seek(arch, 0);          { 2. Actualizo la cabecera SIEMPRE }
                       write(arch, n_aux);    // Si n_aux.cod era 0, la cabecera queda en 0.
                           
                       seek(arch, pos_libre); { 3. Grabo la novela nueva en el lugar recuperado }
                       write(arch, n);
                     end;            
                 end;  
               end;
               
         'j': begin
                  leer(n);
                  ok := true;
                  
                  // Salo a la cabecera (pos 0) porque ahí no hay novelas reales
                  seek(arch, 1);
                  while (not(EOF(arch)) and (ok)) do
                    begin
                      read(arch, n_aux);
                      if (n.cod = n_aux.cod) then
                        begin
                          ok := false;
                          seek(arch, filepos(arch)-1);
                          write(arch, n);
                        end;
                      
                    end;
                end;
                
          'k': begin
                    ok := true;
                    readln(cod);
                    
                    seek(arch, 1);
                    while (not(EOF(arch)) and (ok)) do
                    begin
                      read(arch, n_aux);
                      if (cod = n_aux.cod) then
                        begin
                          ok := false;
                          pos := filepos(arch)-1;
                        end;
                    end;
                    //SI LO ENCUENTRO, HAGO EL INTERCAMBIO (Afuera del while)
                    if (ok = false) then
                      begin
                        // Paso A: Leer cabecera
                        seek(arch, 0);
                        read(arch, n_aux); // cabecera(n_aux) ahora tiene el enlace anterior (ej: un -5 o un 0)
                      
                        // Paso B: El registro borrado hereda lo que decía la cabecera
                        seek(arch, pos);
                        write(arch, n_aux); // Ahora el registro 8 "apunta" al que seguía (al 5)
                        
                        // Paso C: La cabecera apunta al nuevo hueco
                        n_aux.cod := pos * -1; 
                        seek(arch, 0);
                        write(arch, n_aux);
                      end;
                    
                  end;
         end;
        close(arch);
    end;
    
    //C ZZZZZZZZZZZZZZZZZZZZZZZ
  
var
  arch: archivo;
  
begin
  assign(arch, 'novelas 2026');
  

end.
