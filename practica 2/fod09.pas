{9. Se necesita contabilizar los votos de las diferentes mesas electorales registradas por
provincia y localidad. Para ello, se posee un archivo con la siguiente información: código de
provincia, código de localidad, número de mesa y cantidad de votos en dicha mesa.
Presentar en pantalla un listado como se muestra a continuación:
Código de Provincia
Código de Localidad Total de Votos
................................ ......................
................................ ......................
Total de Votos Provincia: ____

Código de Provincia
Código de Localidad Total de Votos
................................ ......................
Total de Votos Provincia: ___
....................................................................
Total General de Votos: ___

NOTA: La información se encuentra ordenada por código de provincia y código de
localidad.}

program ejercicio9;

const
  valorGrande = 9999;

type
  voto = record
    cod_prov, cod_loc, nro_mesa, cant_votos_mesa: integer;
  end;
  
  archivo = file of voto;
  
  procedure leer(var arch: archivo; var v: voto);
    begin
      if (not(EOF(arch))) then
        read(arch, v)
      else
        v.cod_prov := valorGrande;
    end;
    
  procedure mostrar(var arch: archivo);
    var
      v: voto;
      total_gen, total_prov, prov, loc, total_loc: integer;
    
    begin
      total_gen := 0;
      leer(arch, v);
      while (v.cod_prov <> valorGrande) do
        begin
          prov := v.cod_prov;
          writeln('Cod provincia: ', prov);
          total_prov := 0;
          
          while (prov = v.cod_prov) do
            begin
              loc := v.cod_loc;
              total_loc := 0;
              writeln('cod localidad: ', loc); 
              while (prov = v.cod_prov) and (loc = v.cod_loc) do
                begin
                  total_loc := total_loc + v.cant_votos_mesa;
                  leer(arch, v);
                end;
                
              write('        total votos localidad: ', total_loc);
              total_prov := total_prov + total_loc;            
            end;
          write('total votos prov: ', total_prov);
          total_gen := total_gen +total_prov;
        end;
      write('total general de votos: ', total_gen);
      close(arch);
    end;
    
var
  arch: archivo;

begin
  assign(arch, 'votos');
  mostrar(arch);

end.  
  
