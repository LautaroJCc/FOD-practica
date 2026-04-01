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
  
  procedure cargar_archivos(var arch: archivo; var arch2: archivo2); //se dispone --- esto se pone?
  
  procedure actualizar(var arch: archivo; var arch2: archivo2; num: integer);
    var 
      cont: integer;
      dat, act: alu2;
      dat2: alumno;    
    begin
      reset(arch);
      reset(arch2);
      
      if (not(EOF(arch2))) then
        begin
          read(arch2, dat);
      
	      while (not(EOF(arch2))) do
	        begin
	          cont := 0;
	          act := dat;
	          
	          while (not(EOF(arch2))) and (dat.cod = act.cod) do
	            begin
	              case (num) of 
	                1: begin
	                     if (dat.aprobo) then
	                       cont := cont +1;
	                   end;
	                2: begin
	                     if (dat.aprobo = false) then
	                       cont := cont +1;
	                   end;
	               end;
	               
	               read(arch2, dat); //sig
	            end;
	          //salgo 
	          read(arch, dat2);
	          while (dat2.cod <> act.cod) and (not EOF(arch)) do //porque en el archivo detalle puede haber 0, 1 o más registros por cada alumno del archivo maestro
                read(arch, dat2);
	          if (num = 1) then
	            dat2.cant_con_final := dat2.cant_con_final + cont
	          else
	            dat2.cant_sin_final := dat2.cant_sin_final + cont;
	          seek(arch, filepos(arch)-1);
	          write(arch, dat2);       
	        end;      
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
      
      while (not(EOF(arch))) do
        begin
          read(arch, dat);
   
          if (dat.cant_sin_final > 4) then
            writeln(arch2, dat.cod, ' ', dat.cant_sin_final, ' ', dat.cant_con_final, ' ', dat.ape, ' ', dat.nom);
        end;      
      close(arch);
      close(arch2);
    end;
    
  
var
  maestro: archivo;
  detalle: archivo2;
  txt: texto;
  topico: 'a'..'b';
  num: 1..2;
  
begin
  assign(maestro, 'maestro');
  assign(detalle, 'detalle');
  assign(txt, 'puntoB.txt');
  
  write('ingrese un topico: '); readln(topico);
  if (topico = 'a') then
    begin
      write('ingrese un num: '); readln(num);
      actualizar(maestro, detalle, num);
    end
  else
    puntoB(maestro, txt);
    
end.
