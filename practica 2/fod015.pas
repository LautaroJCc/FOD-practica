{
15. Se desea modelar la información de una ONG dedicada a la asistencia de personas con
carencias habitacionales. La ONG cuenta con un archivo maestro conteniendo información
como se indica a continuación: Código pcia, nombre provincia, código de localidad, nombre
de localidad, #viviendas sin luz, #viviendas sin gas, #viviendas de chapa, #viviendas sin
agua,# viviendas sin sanitarios.
Mensualmente reciben detalles de las diferentes provincias indicando avances en las obras
de ayuda en la edificación y equipamientos de viviendas en cada provincia. La información
de los detalles es la siguiente: Código pcia, código localidad, #viviendas con luz, #viviendas
construidas, #viviendas con agua, #viviendas con gas, #entrega sanitarios.
Se debe realizar el procedimiento que permita actualizar el maestro con los detalles
recibidos, se reciben 10 detalles. Todos los archivos están ordenados por código de
provincia y código de localidad.
Para la actualización se debe proceder de la siguiente manera:
1. Al valor de vivienda con luz se le resta el valor recibido en el detalle.
2. Idem para viviendas con agua, gas y entrega de sanitarios.
3. A las viviendas de chapa se le resta el valor recibido de viviendas construidas

La misma combinación de provincia y localidad aparecen a lo sumo una única vez.

Realice las declaraciones necesarias, el programa principal y los procedimientos que
requiera para la actualización solicitada e informe cantidad de localidades sin viviendas de
chapa (las localidades pueden o no haber sido actualizadas).
}

program ejercicio15;

const
  dimf = 10;
  valorGrande = 9999;
  
type
  info = record
    cod_pcia, cod_loc, v_sin_luz, v_sin_gas, v_de_chapa, v_sin_agua, v_sin_sanitarios: integer;
    nom_prov, nom_loc: string;
  end;
  
  maestro = file of info;
  
  info2 = record
    cod_pcia, cod_loc: integer;
    v_con_luz, v_construidas, v_con_agua, v_con_gas, entrega_sanitarios: integer;
  end;
  
  detalle = file of info2;
  
  detalles = array [1..dimf] of detalle;
  reg_det = array [1..dimf] of info2;
  
  procedure leer1(var arch: detalle; var d: info2);
    begin
      if (not(EOF(arch))) then
        read(arch, d)
      else
        d.cod_pcia := valorGrande;
    end;
    
  procedure leer2(var arch: maestro; var d: info);
    begin
      if (not(EOF(arch))) then
        read(arch, d)
      else
        d.cod_pcia := valorGrande;
    end;
  
  procedure cargar(var v: detalles; var v2: reg_det);
    var
      i: integer;
      nombre: string;
    begin
      for i:=1 to dimf do
        begin
          write('ingrese nombre del detalle: '); readln(nombre);
          assign(v[i], nombre);
          reset(v[i]);
          leer1(v[i], v2[i]);
        end;
    end;
    
  procedure minimo(var v: detalles; var v2: reg_det; var min: info2);
    var
      i, cod_p, cod_l, pos: integer;   
      
    begin
      cod_p := valorGrande;
      cod_l := valorGrande;
      pos := -1;
      
      for i:=1 to dimf do
        begin
          if (v2[i].cod_pcia < cod_p) or ((v2[i].cod_pcia = cod_p) and (v2[i].cod_loc < cod_l)) then
            begin
              min := v2[i];
              pos := i;
              cod_p := v2[i].cod_pcia;
              cod_l := v2[i].cod_loc;
            end;      
        end;
      if (pos <> -1) then
        leer1(v[i], v2[i]);  
    end;
    
  procedure cerrar(var v: detalles);
    var
      i: integer;
    begin
      for i:=1 to dimf do
        close(v[i]);
    end;
    
  procedure actualizar(var v: detalles; var m: maestro);
    var
      v2: reg_det;
      min: info2;
      d: info;
      
    begin
      assign(m, 'maestro');
      reset(m);
    
      cargar(v, v2);
      minimo(v, v2, min);
      
      leer2(m, d);
      while (min.cod_pcia <> valorGrande) do
        begin 
          while (d.cod_pcia <> min.cod_pcia) or (d.cod_loc <> min.cod_loc) do //checar ese or
            leer2(m, d);
          //  2. Idem para viviendas con agua, gas y entrega de sanitarios
          d.v_sin_luz := d.v_sin_luz - min.v_con_luz;
          d.v_de_chapa := d.v_de_chapa - min.v_construidas;
          d.v_sin_agua := d.v_sin_agua - min.v_con_agua;
          d.v_sin_gas := d.v_sin_gas - min.v_con_gas;
          d.v_sin_sanitarios := d.v_sin_sanitarios - min.entrega_sanitarios;
          
          seek(m, filepos(m)-1);
          write(m, d);
          
          minimo(v, v2, min);
        end;
      cerrar(v);
    end;
  
var
  v: detalles;
  m: maestro;
  
begin
  actualizar(v, m);
end.
