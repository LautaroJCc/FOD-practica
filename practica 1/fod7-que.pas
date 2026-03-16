program ejercicio7;

type
  novela = record
    cod: integer;
    nombre, gen: string;
    precio: real;
  end;

  texto = text;
  archivo = file of novela;
  
  //A
  procedure puntoA(var arch: archivo; var arch2: texto);
    var
      nov: novela;
    begin
      reset(arch2);
      rewrite(arch);
      
      while (not(EOF(arch2))) do
        begin
          readln(arch2, nov.cod, nov.precio, nov.gen);
          readln(arch2, nov.nombre);
          
          write(arch, nov);
        end;
      close(arch);
      close(arch2);
    end;
    
  procedure agregar(var arch: archivo);
    var
      nov: novela;
    begin
      reset(arch);
      seek(arch, filesize(arch));      { mueve puntero al final del archivo }
      
      readln(nov.cod);
      readln(nov.precio);
      readln(nov.gen);
      readln(nov.nombre);
    
      write(arch, nov);
      
      close(arch);
    end;
    
  //procedure modificar(QUE COSA MODIFICA????');
  
  //B
  procedure puntoB(var arch: archivo);
    var
      nov: novela;
      num: integer;
    begin
      write('1 para agregar una novela, 2 para modificar una existente: '); readln(num);
      case (num) of
        1:  agregar(arch);
        //2:
      end;
    end;  
var
  archivo_logico: archivo;
  txt: texto;
  nombre: string;
  
begin
  assign(txt, 'novelas.txt');
  write('ingrese nombre del archivo binario: '); readln(nombre);
  assign(archivo_logico, nombre);
  
  puntoA(archivo_logico, txt);
  //puntoB()

end.
  
