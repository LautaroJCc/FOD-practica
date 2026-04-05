{
2. Se necesita contabilizar los votos de las diferentes mesas electorales registradas por
localidad en la provincia de Buenos Aires. Para ello, se posee un archivo con la
siguiente información: código de localidad, número de mesa y cantidad de votos en
dicha mesa. Presentar en pantalla un listado como se muestra a continuación:
Código de Localidad Total de Votos
................................ ......................
................................ ......................
Total General de Votos: ..................
NOTAS:
● La información en el archivo no está ordenada por ningún criterio.
● Trate de resolver el problema sin modificar el contenido del archivo dado.
● Puede utilizar una estructura auxiliar, como por ejemplo otro archivo, para
llevar el control de las localidades que han sido procesadas.
}

program ejercicio2_part2;

const
  valorGrande = 9999;

type
  reg_voto = record
    cod_localidad: integer;
    num_mesa: integer;
    cant_votos: integer;
  end;

  archivo_votos = file of reg_voto;
  
  r2 = record
    cod_localidad, cant_votos: integer;
  end;
  
  archivo_aux = file of r2;
  
  procedure leer1(var a: archivo_votos; var aux: reg_voto);
    begin
      if (not(EOF(a))) then
        read(a, aux)
      else
        aux.cod_localidad := valorGrande;
    end;
    
  procedure leer2(var a: archivo_aux; var aux: r2);
    begin
      if (not(EOF(a))) then
        read(a, aux)
      else
        aux.cod_localidad := valorGrande;
    end;
  
  procedure buscar(var a: archivo_aux; cod: integer; var pos: integer; var ok: boolean);
    var
      r: r2;
     
    begin
      ok := false; // Inicializo siempre en falso
      seek(a, 0);
      
      while (not(EOF(a))) and (ok = false) do
        begin
          read(a, r);
         
          if (r.cod_localidad = cod) then
            begin
              ok := true;
              pos := filepos(a)-1;
            end; 
        end;
     end;
     
	procedure imprimirA2(var a2: archivo_aux);
		var
		  r: r2;
		  total: integer;
		begin
		  total := 0;

		  writeln('Codigo de Localidad   Total de Votos');
		  writeln('-------------------------------------');

		  while not eof(a2) do
		  begin
			read(a2, r);
			writeln(r.cod_localidad, '   ', r.cant_votos);
			total := total + r.cant_votos;
		  end;
		  close(a2);

		  writeln('-------------------------------------');
		  writeln('Total General de Votos: ', total);
		end;
    
  procedure cargarA2(var a1: archivo_votos; var a2: archivo_aux);
    var
      re: reg_voto;
      r: r2;
      ok: boolean;
      pos_aux: integer;
      
    begin
      rewrite(a2);
      reset(a1);
      
      leer1(a1, re);
      while (re.cod_localidad <> valorGrande) do
        begin
          buscar(a2, re.cod_localidad, pos_aux, ok);
          
          if (ok) then
            begin
              seek(a2, pos_aux);
              read(a2, r);
              seek(a2, pos_aux);
              r.cant_votos := r.cant_votos + re.cant_votos;
              write(a2, r);
            end
          else
            begin
              seek(a2, filesize(a2));
              r.cod_localidad := re.cod_localidad;
              r.cant_votos := re.cant_votos;
              write(a2, r);
            end;
          
          leer1(a1, re);
        end;
      close(a1);
      
      //imprimir
      seek(a2, 0);
      imprimirA2(a2);
      
      close(a2);
    end;
    
var
  a1: archivo_votos;
  a2: archivo_aux;

begin
  assign(a1, 'votos');
  assign(a2, 'aux');
  
  cargarA2(a1, a2);
end.
