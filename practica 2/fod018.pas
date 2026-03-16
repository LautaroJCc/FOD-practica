{
18 . Se cuenta con un archivo con información de los casos de COVID-19 registrados en los
diferentes hospitales de la Provincia de Buenos Aires cada día. Dicho archivo contiene:
cod_localidad, nombre_localidad, cod_municipio, nombre_minucipio, cod_hospital,
nombre_hospital, fecha y cantidad de casos positivos detectados.
El archivo está ordenado por localidad, luego por municipio y luego por hospital.
a. Escriba la definición de las estructuras de datos necesarias y un procedimiento que haga
un listado con el siguiente formato:
Nombre: Localidad 1
Nombre: Municipio 1
Nombre Hospital 1.................Cantidad de casos Hospital 1
..........................
Nombre Hospital N................Cantidad de casos Hospital N
Cantidad de casos Municipio 1
...............................................................................
Nombre Municipio N
Nombre Hospital 1.................Cantidad de casos Hospital 1
..........................
NombreHospital N................Cantidad de casos Hospital N
Cantidad de casos Municipio N
Cantidad de casos Localidad 1
-----------------------------------------------------------------------------------------
Nombre Localidad N
Nombre Municipio 1

Nombre Hospital 1.................Cantidad de casos Hospital 1
..........................
Nombre Hospital N................Cantidad de casos Hospital N
Cantidad de casos Municipio 1
...............................................................................
Nombre Municipio N
Nombre Hospital 1.................Cantidad de casos Hospital 1
..........................
Nombre Hospital N................Cantidad de casos Hospital N
Cantidad de casos Municipio N
Cantidad de casos Localidad N
Cantidad de casos Totales en la Provincia

b. Exportar a un archivo de texto la siguiente información nombre_localidad,
nombre_municipio y cantidad de casos de municipio, para aquellos municipios cuya
cantidad de casos supere los 1500. El formato del archivo de texto deberá ser el
adecuado para recuperar la información con la menor cantidad de lecturas posibles.
NOTA: El archivo debe recorrerse solo una vez.
}

program ejercicio18;

const
  max_dia = 31;
  max_mes = 12;
  valorGrande = 'ZZZZ';
  max = 1500;

type
  rango_dia = 1..max_dia;
  rango_mes = 1..max_mes;

  fecha = record
    dia: rango_dia;
    mes: rango_mes;
    anio: integer;
  end;

  hospital = record
    cod_localidad, cod_municipio, cod_hospital, cant_casos_pos_detec: integer;
    nombre_localidad, nombre_municipio, nombre_hospital: string;
    f: fecha;
  end;
  
  archivo = file of hospital; //maestro o detalle? es maestro
  
  procedure leer(var arch: archivo; var h: hospital);
    begin
      if (not(EOF(arch))) then 
        read(arch, h)
      else
        h.nombre_localidad := valorGrande;
    end;
    
  procedure informar(var arch: archivo; var txt: text);
    var
      h: hospital;
      loc, mun, hos: string;
      tot_prov, tot_mun, tot_hos, tot_loc: integer;
      
    begin 
      assign(arch, 'archivo');
      reset(arch);
    
      leer(arch, h);
      
      tot_prov := 0;
      while (h.nombre_localidad <> valorGrande) do
        begin
          loc := h.nombre_localidad;
          tot_loc := 0;
          writeln('nombre localidad: ', loc); 
          
          while (h.nombre_localidad = loc) do
            begin
              tot_mun := 0;
              mun := h.nombre_municipio;
              writeln('nombre muni: ', mun);
              
              while (h.nombre_localidad = loc) and (h.nombre_municipio = mun) do
                begin
                  tot_hos := 0;
                  hos := h.nombre_hospital;
                  writeln('nombre hospital: ', hos);
                  
                  while (h.nombre_localidad = loc) and (h.nombre_municipio = mun) and (h.nombre_hospital = hos) do
                    begin
                      tot_hos := tot_hos + h.cant_casos_pos_detec;
                    
                      leer(arch, h);  
                    end;
                  writeln('cant casos hospital: ', tot_hos);
                  tot_mun := tot_mun + tot_hos;
                  
                end;
              writeln('cant casos municipio: ', tot_mun);
              
              //b nombre_localidad,
              if (tot_mun > max) then
                writeln(txt, loc, ' ', mun, ' ', tot_mun);
              
              tot_loc := tot_loc + tot_mun;             
            
            end;
          writeln('cant de casos localidad: ', tot_loc);
          tot_prov := tot_prov + tot_loc;      
        end;
      writeln('cant de casos totales prov: ', tot_prov);
      close(txt);
    end;
    
var
  arch: archivo;
  txt: text;
  
begin
  assign(txt, 'texto.txt');
  reset(txt); 

  informar(arch, txt);
end.
