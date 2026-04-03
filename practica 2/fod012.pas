{12. La empresa de software ‘X’ posee un servidor web donde se encuentra alojado el sitio de
la organización. En dicho servidor, se almacenan en un archivo todos los accesos que se
realizan al sitio.
La información que se almacena en el archivo es la siguiente: año, mes, dia, idUsuario y
tiempo de acceso al sitio de la organización. El archivo se encuentra ordenado por los
siguientes criterios: año, mes, dia e idUsuario.
Se debe realizar un procedimiento que genere un informe en pantalla, para ello se indicará
el año calendario sobre el cual debe realizar el informe. El mismo debe respetar el formato
mostrado a continuación:
Año : ---
Mes:-- 1
día:-- 1
idUsuario 1 Tiempo Total de acceso en el dia 1 mes 1
--------
idusuario N Tiempo total de acceso en el dia 1 mes 1
Tiempo total acceso dia 1 mes 1
-------------
día N
idUsuario 1 Tiempo Total de acceso en el dia N mes 1
--------
idusuario N Tiempo total de acceso en el dia N mes 1
Tiempo total acceso dia N mes 1
Total tiempo de acceso mes 1

------
Mes 12
día 1
idUsuario 1 Tiempo Total de acceso en el dia 1 mes 12
--------
idusuario N Tiempo total de acceso en el dia 1 mes 12
Tiempo total acceso dia 1 mes 12
-------------
día N
idUsuario 1 Tiempo Total de acceso en el dia N mes 12
--------
idusuario N Tiempo total de acceso en el dia N mes 12
Tiempo total acceso dia N mes 12
Total tiempo de acceso mes 12
Total tiempo de acceso año
Se deberá tener en cuenta las siguientes aclaraciones:
- El año sobre el cual realizará el informe de accesos debe leerse desde teclado.
- El año puede no existir en el archivo, en tal caso, debe informarse en pantalla “año
no encontrado”.
- Debe definir las estructuras de datos necesarias.
- El recorrido del archivo debe realizarse una única vez procesando sólo la información
necesaria.}

program ejercicio12;

const
  max_mes = 12;
  max_dia = 31;
  valorGrande = 9999;
  
type
  rango_mes = 1..max_mes;
  rango_dia = 1..max_dia;
  
  acceso = record
    anio, id_usuario, tiempo_acceso, total_aux: integer;
    mes: rango_mes;
    dia: rango_dia;
  end;
  
  archivo = file of acceso;
  
  procedure leer(var arch: archivo; var ac: acceso);
    begin
      if (not(EOF(arch))) then
        read(arch, ac)
      else
        ac.anio := valorGrande;
    end;
  
  procedure informar(var arch: archivo);
    var
      ac: acceso;
      anio, id, tiempo_mes, tiempo_anio, tiempo_id, total_aux: integer;
      mes: rango_mes;
      dia: rango_dia;   
      
    begin
      reset(arch);
      write('ingrese un anio: '); readln(anio);
      
      leer(arch, ac);
      while (ac.anio <> valorGrande) and (ac.anio < anio) do
        leer(arch, ac);
        
      if (ac.anio =  anio) then
        begin
          tiempo_anio := 0;
          writeln('anio: ', anio);
          while (ac.anio =  anio) do
            begin
              mes := ac.mes;
              tiempo_mes := 0;
              writeln('mes: ', mes);
              while (ac.anio =  anio) and (mes = ac.mes) do
                begin
                  dia := ac.dia;
                  writeln('dia: ', dia);
                  total_aux := 0;
                  while (ac.anio =  anio) and (mes = ac.mes) and (dia = ac.dia) do
                    begin
                      id := ac.id_usuario;
                      tiempo_id := 0;
                      while (ac.anio =  anio) and (mes = ac.mes) and (dia = ac.dia) and (id = ac.id_usuario) do
                        begin
                          tiempo_id := tiempo_id + ac.tiempo_acceso;              
                                                   
                          leer(arch, ac);
                        end; 
                      writeln('id usuario: ', id, ' tiempo de accedo en el dia: ', dia, ' del mes: ', mes, ' : ',tiempo_id);
                      total_aux := total_aux + tiempo_id;                  
                    end;  
                  writeln(' tiempo total de acceso en el dia: ', dia, ' del mes: ', mes, ' : ', total_aux);
                  tiempo_mes := tiempo_mes + total_aux;                                   
                end;
              writeln('Total tiempo de acceso mes ', mes, ': ', tiempo_mes);
              tiempo_anio := tiempo_anio +  tiempo_mes;
            end;      
          writeln('total tiempo acceso anio: ', tiempo_anio); 
        end        
      else
        writeln('anio no encontrado');
        
      close(arch);
    end; 

var
  arch: archivo;

begin
  assign(arch, 'archivo');
  informar(arch);
end.
