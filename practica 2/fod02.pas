program ejercicio2;

type
  alumno = record
    cod, cant_sin_final, cant_con_final: integer;
    ape, nom: string;
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
