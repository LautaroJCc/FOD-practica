{
2. Se dispone de un archivo con información de los alumnos de la Facultad de Informática. Por
cada alumno se dispone de su código de alumno, apellido, nombre, cantidad de materias
(cursadas) aprobadas sin final y cantidad de materias con final aprobado. Además, se tiene
un archivo detalle con el código de alumno e información correspondiente a una materia
(esta información indica si aprobó la cursada o aprobó el final).
Todos los archivos están ordenados por código de alumno y en el archivo detalle puede
haber 0, 1 ó más registros por cada alumno del archivo maestro. Se pide realizar un
programa con opciones para:

a. Actualizar el archivo maestro de la siguiente manera:
i.Si aprobó el final se incrementa en uno la cantidad de materias con final aprobado.
ii.Si aprobó la cursada se incrementa en uno la cantidad de materias aprobadas sin
final.
b. Listar en un archivo de texto los alumnos que tengan más de cuatro materias
con cursada aprobada pero no aprobaron el final. Deben listarse todos los campos.
NOTA: Para la actualización del inciso a) los archivos deben ser recorridos sólo una vez.
}

program ejercicio2;

const
  valor_grande = 9999;

type
  alumno = record
    cod, cant_sin_final, cant_con_final: integer;
    ape, nom: string[50];
  end;
  
  alu2 = record
    cod: integer;
    aprobo: boolean; //true final, false cursada
  end;
  
  archivo = file of alumno;
  archivo2 = file of alu2;
  texto = text;
  
  //procedure cargar_archivos(var arch: archivo; var arch2: archivo2); //se dispone --- esto se pone?
  
  procedure leer1(var arch: archivo; var a: alumno);
    begin
      if (not(EOF(arch))) then
        read(arch, a)
      else
        a.cod := valor_grande;
    end;
    
  procedure leer2(var arch: archivo2; var a: alu2);
    begin
      if (not(EOF(arch))) then
        read(arch, a)
      else
        a.cod := valor_grande;
    end;
  
  procedure actualizar(var arch: archivo; var arch2: archivo2);
    var
      dat: alumno;
      dat2: alu2; 
      aprobo, desaprobo, act_cod: integer;
      
    begin
      reset(arch);
      reset(arch2);
      
      leer1(arch, dat);
      leer2(arch2, dat2);
      while (dat2.cod <> valor_grande) do
        begin
          act_cod := dat2.cod;
          aprobo := 0;
          desaprobo := 0;
          
          while (act_cod = dat2.cod) do
            begin
              if (dat2.aprobo) then
                aprobo := aprobo +1
              else
                desaprobo := desaprobo +1;
              
              leer2(arch2, dat2);
            end;            
          while (dat.cod <> act_cod) do
            leer1(arch, dat);
              
          if (dat.cod <> valor_grande) then
            begin
              if (aprobo > 0) then
                dat.cant_con_final := dat.cant_con_final + aprobo
              else if (desaprobo > 0) then
                dat.cant_sin_final := dat.cant_sin_final + desaprobo;
            end;
            
          // Vuelvo una posición atrás para sobreescribir el registro correcto
          seek(arch, filepos(arch) - 1);
          write(arch, dat);
        end;
      close(arch);
      close(arch2);
    end; 
    
  procedure puntoB(var arch: archivo; var arch2: texto);
    var 
      dat: alumno;
    begin
      reset(arch);
      rewrite(arch2);
      
      leer1(arch, dat);
      while (dat.cod <> valor_grande) do
        begin
          if (dat.cant_sin_final > 4) then
            writeln(arch2, dat.cod, ' ', dat.cant_sin_final, ' ', dat.cant_con_final, ' ', dat.ape, ' ', dat.nom);
            
          leer1(arch, dat);
        end;      
      close(arch);
      close(arch2);
    end;
    
var
  maestro: archivo;
  detalle: archivo2;
  txt: texto;
  
begin
  assign(maestro, 'maestro');
  assign(detalle, 'detalle');
  assign(txt, 'puntoB.txt');

  //fala menu japa
  actualizar(maestro, detalle);
  puntoB(maestro, txt);   
end.
      
